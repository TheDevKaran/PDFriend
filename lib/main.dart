import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdfriend/routes.dart';
import 'package:pdfriend/RealHome.dart';
import 'package:pdfriend/chat/screens/chat.dart';
import 'package:pdfriend/chat/screens/upload_pdf.dart';
import 'package:pdfriend/startup%20screens/chatpdfIntro.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        onGenerateRoute: (settings) => generateRoute(settings),
      home:
      ChatPDFIntro()
      // RealHome()
    );
  }
}

