import 'dart:io';
import 'package:flutter/services.dart';
import 'package:langchain/langchain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/config.dart';
import '../langchain_service_impl.dart';
part 'index_notifier.g.dart';

enum IndexState {
  initial,
  loading,
  loaded,
  error,
}

@riverpod
@riverpod
class IndexNotifier extends _$IndexNotifier {
  @override
  IndexState build() => IndexState.initial;

  void createAndUploadPineConeIndex(String pdfFilePath) async {
    const vectorDimension = 1536;
    state = IndexState.loading;

    try {
      await ref.read(langchainServiceProvider).createPineConeIndex(ServiceConfig.indexName, vectorDimension);

      final docs = await fetchDocuments(pdfFilePath);

      await ref.read(langchainServiceProvider).updatePineConeIndex(ServiceConfig.indexName, docs);

      state = IndexState.loaded;
    } catch (e) {
      state = IndexState.error;
    }
  }

  Future<List<Document>> fetchDocuments(String pdfFilePath) async {
    try {
      final textFilePathFromPdf = await convertPdfToTextAndSaveInDir(pdfFilePath);
      final loader = TextLoader(textFilePathFromPdf);
      final documents = await loader.load();

      return documents;
    } catch (e) {
      throw Exception('Error creating pinecone documents');
    }
  }

  Future<String> convertPdfToTextAndSaveInDir(String pdfFilePath) async {
    try {
      final document = PdfDocument(inputBytes: File(pdfFilePath).readAsBytesSync());

      String text = PdfTextExtractor(document).extractText();
      final localPath = await _localPath;
      File file = File('$localPath/output.txt');
      final res = await file.writeAsString(text);

      document.dispose();

      return res.path;
    } catch (e) {
      throw Exception('Error converting pdf to text');
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
