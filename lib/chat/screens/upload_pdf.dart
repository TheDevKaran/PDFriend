import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/notifiers/index_notifier.dart';
import '../services/pickpdf.dart';

class UploadPDF extends HookConsumerWidget {
  static const String routeName = '/home';
  const UploadPDF({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexState = ref.watch(indexNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('PDFriend'),centerTitle: true,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final pdfFilePath = await pickPdfFile();
                  if (pdfFilePath != null) {
                    ref.read(indexNotifierProvider.notifier).createAndUploadPineConeIndex(pdfFilePath);
                  }
                },
                child: const Text('Upload PDF'),
              ),
              const SizedBox(height: 20),
              if (indexState == IndexState.loading)
                const LinearProgressIndicator(),
              if (indexState == IndexState.loaded)
                AlertDialog(backgroundColor: Colors.teal.shade300, contentTextStyle: TextStyle(color: Colors.white),
                  title: const Text('Upload Successful', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  content: const Text('Do you want to talk about the uploaded PDF?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(color: Colors.white , height: 30, width: 30 ,child: Center(child: const Text('No', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/my-chat-page'),
                        child: Container(color: Colors.white , height: 30, width: 30 ,child: Center(child: const Text('Yes', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))))
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
