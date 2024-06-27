import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:langchain_pinecone/langchain_pinecone.dart';
import 'package:pinecone/pinecone.dart';
import '../core/config.dart';
import '../services/langchain_service_impl.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/my-chat-page';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isSending = false;
  bool _isTyping = false;
  late LangChainService _langChainService; // Declare LangChainService variable
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _langChainService = LangchainServiceImpl( // Initialize LangchainServiceImpl here
      client: PineconeClient(
        apiKey: dotenv.env['PINECONE_API_KEY']!,
        baseUrl: 'https://controller.${dotenv.env['PINECONE_ENVIRONMENT']}.pinecone.io',
      ),
      langchainPinecone: Pinecone(
        apiKey: dotenv.env['PINECONE_API_KEY']!,
        indexName: ServiceConfig.indexName,
        environment: dotenv.env['PINECONE_ENVIRONMENT']!,
        embeddings: OpenAIEmbeddings(
          apiKey: dotenv.env['OPENAI_API_KEY']!,
          model: 'text-embedding-ada-002',
        ),
      ),
      embeddings: OpenAIEmbeddings(
        apiKey: dotenv.env['OPENAI_API_KEY']!,
        model: 'text-embedding-ada-002',
      ),
      openAI: ChatOpenAI(
        apiKey: dotenv.env['OPENAI_API_KEY']!,
        model: 'gpt-3.5-turbo',
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage(String messageText) async {
    setState(() {
      _isSending = true;
      _messages.add(Message(text: messageText, isMe: true));
      _controller.clear(); // Clear the input field
      _isTyping = true; // Show "pdfriend is typing"
    });

    try {
      final response = await _langChainService.queryPineConeVectorStore(ServiceConfig.indexName, messageText);

      setState(() {
        _messages.add(Message(text: response, isMe: false));
        _isSending = false;
        _isTyping = false; // Hide "pdfriend is typing"
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _messages.add(Message(text: 'Error: $e', isMe: false));
        _isSending = false;
        _isTyping = false; // Hide "pdfriend is typing"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDFriend'), centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'pdfriend is typing',
                          style: TextStyle(color: Colors.black),
                        ),
                        TypingIndicator(animationController: _animationController),
                      ],
                    ),
                  );
                }
                final message = _messages[index];
                return Align(
                  alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: message.isMe ? Colors.deepPurple : Colors.grey[300],
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75, // Limit message width
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(color: message.isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Ask Your Question'),
                    enabled: !_isSending,
                    onSubmitted: (value) => _sendMessage(value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isSending ? null : () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  final AnimationController animationController;

  TypingIndicator({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8), // Add some space between text and dots
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end, // Align dots at the bottom
        children: [
          Dot(animationController: animationController, delay: 0),
          SizedBox(width: 4),
          Dot(animationController: animationController, delay: 200),
          SizedBox(width: 4),
          Dot(animationController: animationController, delay: 400),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final AnimationController animationController;
  final int delay;

  Dot({required this.animationController, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (animationController.value - 0.5).abs()),
          child: child,
        );
      },
      child: Container(
        width: 8,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}
