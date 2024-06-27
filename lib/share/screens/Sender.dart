import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/textsender_service.dart';

class SendingScreen extends StatefulWidget {
  static const String routeName = '/sender';

  @override
  _SendingScreenState createState() => _SendingScreenState();
}

class _SendingScreenState extends State<SendingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();

  Future<void> _sendMessage() async {
    final String message = _messageController.text;

    // Check if the message field is filled
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _messageService.sendMessage(message);
        final String otp = response['otp'] as String;

        // Show the OTP in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Message Sent'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Your message has been sent.'),
                    SizedBox(height: 20),
                    Text('Your OTP is: $otp'),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: otp));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('OTP copied to clipboard')),
                        );

                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pushNamed('/document-share'); // Navigate to the document-share screen
                      },
                      child: Text('Copy OTP'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();

                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pushNamed('/document-share');
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('$e'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(labelText: 'Message'),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send Message'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
