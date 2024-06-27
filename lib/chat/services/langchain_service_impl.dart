import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:langchain_pinecone/langchain_pinecone.dart';
import 'package:pinecone/pinecone.dart';

import '../core/config.dart';

final langchainServiceProvider = Provider<LangChainService>((ref) {
  final pineConeApiKey = dotenv.env['PINECONE_API_KEY']!;
  final environment = dotenv.env['PINECONE_ENVIRONMENT']!;
  final openAIApiKey = dotenv.env['OPENAI_API_KEY']!;

  final pineconeClient = PineconeClient(
    apiKey: pineConeApiKey,
    baseUrl: 'https://controller.$environment.pinecone.io',
  );

  final embeddings = OpenAIEmbeddings(
    apiKey: openAIApiKey,
    model: 'text-embedding-ada-002', // This is typically used for embeddings
  );

  final langchainPinecone = Pinecone(
    apiKey: pineConeApiKey,
    indexName: ServiceConfig.indexName,
    embeddings: embeddings,
    environment: environment,
  );

  final chatopenAI = ChatOpenAI(
    apiKey: openAIApiKey,
    model: 'gpt-3.5-turbo', // Ensure correct model is specified
  );

  return LangchainServiceImpl(
    client: pineconeClient,
    langchainPinecone: langchainPinecone,
    embeddings: embeddings,
    openAI: chatopenAI,
  );
});

abstract class LangChainService {
  Future<void> createPineConeIndex(String indexName, int vectorDimension);
  Future<String> queryPineConeVectorStore(String indexName, String query);
  Future<void> updatePineConeIndex(String indexname, List<Document> docs);
}

class LangchainServiceImpl implements LangChainService {
  final PineconeClient client;
  final Pinecone langchainPinecone;
  final OpenAIEmbeddings embeddings;
  final ChatOpenAI openAI;

  LangchainServiceImpl({
    required this.client,
    required this.langchainPinecone,
    required this.embeddings,
    required this.openAI,
  });

  @override
  Future<void> createPineConeIndex(String indexName, int vectorDimension) async {
    print("Checking $indexName");
    final indexes = await client.listIndexes();
    try {
      if (!indexes.contains(indexName)) {
        print("Creating $indexName ...");
        await client.createIndex(
          environment: dotenv.env['PINECONE_ENVIRONMENT']!,
          request: CreateIndexRequest(
            name: indexName,
            dimension: vectorDimension,
            metric: SearchMetric.cosine,
          ),
        );
        print('Creating index.... please wait for it to finish initializing.');
      } else {
        print("$indexName already exists");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<String> queryPineConeVectorStore(String indexName, String query) async {
    try {
      final index = await client.describeIndex(
        indexName: indexName,
        environment: dotenv.env['PINECONE_ENVIRONMENT']!,
      );
      final queryEmbedding = await embeddings.embedQuery(query);
      final result = await PineconeClient(
        apiKey: dotenv.env['PINECONE_API_KEY']!,
        baseUrl: 'https://${index.name}-${index.projectId}.svc.${index.environment}.pinecone.io',
      ).queryVectors(
        indexName: index.name,
        projectId: index.projectId,
        environment: index.environment,
        request: QueryRequest(
          topK: 2,
          vector: queryEmbedding,
          includeMetadata: true,
          includeValues: true,
        ),
      );
      if (result.matches.isNotEmpty) {
        final concatPageContent = result.matches.map((e) {
          if (e.metadata == null) return '';
          if (e.metadata!.containsKey('pageContent')) {
            return e.metadata!['pageContent'];
          } else {
            return '';
          }
        }).join(' ');

        final docChain = StuffDocumentsQAChain(llm: openAI);
        final response = await docChain.call({
          'input_documents': [Document(pageContent: concatPageContent)],
          'question': query,
        });

        print(response);

        return response['output'];
      } else {
        return 'No results found';
      }
    } catch (e) {
      print(e);
      throw Exception('Error querying pinecone index');
    }
  }

  @override
  Future<void> updatePineConeIndex(String indexname, List<Document> docs) async {
    try {
      print("Retrieving Pinecone index...");
      final index = await client.describeIndex(
        indexName: indexname,
        environment: dotenv.env['PINECONE_ENVIRONMENT']!,
      );
      print('Pinecone index retrieved: ${index.name}');

      for (final doc in docs) {
        print('Processing document: ${doc.metadata['source']}');
        final txtPath = doc.metadata['source'] as String;
        final text = doc.pageContent;

        const textSplitter = RecursiveCharacterTextSplitter(chunkSize: 1000);

        final chunks = textSplitter.createDocuments([text]);

        print('Text split into ${chunks.length} chunks');

        print('Calling OpenAI\'s Embedding endpoint documents with ${chunks.length} text chunks ...');

        final chunksMap = chunks.map(
              (e) => Document(
            id: e.id,
            pageContent: e.pageContent.replaceAll(RegExp('/\n/g'), "  "),
            metadata: doc.metadata,
          ),
        ).toList();

        final embeddingArrays = await embeddings.embedDocuments(chunksMap);
        print('Finished embedding documents');
        print('Creating ${chunks.length} vectors array with id, values, and metadata...');

        const batchSize = 100;
        for (int i = 0; i < chunks.length; i++) {
          final chunk = chunks[i];
          final embeddingArray = embeddingArrays[i];

          List<Vector> chunkVectors = [];

          final chunkVector = Vector(
            id: '${txtPath}_$i',
            values: embeddingArray,
            metadata: {
              ...chunk.metadata,
              'loc': jsonEncode(chunk.metadata['loc']),
              'pageContent': chunk.pageContent,
              'txtPath': txtPath,
            },
          );

          chunkVectors.add(chunkVector);

          try {
            await PineconeClient(
              apiKey: dotenv.env['PINECONE_API_KEY']!,
              baseUrl: 'https://${index.name}-${index.projectId}.svc.${index.environment}.pinecone.io',
            ).upsertVectors(
              indexName: index.name,
              environment: index.environment,
              projectId: index.projectId,
              request: UpsertRequest(vectors: chunkVectors),
            );

            print('Pinecone index updated with ${chunkVectors.length} vectors');

            chunkVectors = [];
          } catch(e) {
            print(e);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
