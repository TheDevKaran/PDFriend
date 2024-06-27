import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import '../services/textsender_service.dart';

class ReceivingScreen extends StatefulWidget {
  static const String routeName = '/receiver';

  @override
  _ReceivingScreenState createState() => _ReceivingScreenState();
}

class _ReceivingScreenState extends State<ReceivingScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MessageService _messageService = MessageService();
  String _receivedMessage = '';
  String _filePath = '';

  Future<void> _receiveMessage() async {
    final String otp = _otpController.text;

    if (_formKey.currentState!.validate()) {
      try {
        final String message = await _messageService.receiveMessage(otp);

        setState(() {
          _receivedMessage = message;
        });

        await _saveMessageToFile();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Message Received'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Your message:'),
                    SizedBox(height: 10),
                    Text(
                      _receivedMessage,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _receivedMessage));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Message copied to clipboard')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            if (_filePath.isNotEmpty) {
                              _downloadFile();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to save the file')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
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
      } catch (e) {
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

  Future<void> _saveMessageToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/message_$timestamp.txt';
      final file = File(path);
      await file.writeAsString(_receivedMessage);

      setState(() {
        _filePath = path;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('File saved at $path')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Occurred $e')),
      );
    }
  }

  Future<void> _downloadFile() async {
    try {
      final params = SaveFileDialogParams(
        sourceFilePath: _filePath,
        fileName: 'received_message.txt',
      );
      final filePath = await FlutterFileDialog.saveFile(params: params);

      if (filePath != null && filePath.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File download was cancelled')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download the file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _receiveMessage,
                child: Text('Receive Message'),
              ),
              SizedBox(height: 20),
              if (_receivedMessage.isNotEmpty) ...[
                Text(
                  'Received Message:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(_receivedMessage),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _receivedMessage));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Message copied to clipboard')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.download),
                      onPressed: _downloadFile,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
