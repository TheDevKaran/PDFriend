import 'package:flutter/material.dart';
import 'package:pdfriend/RealHome.dart';
import 'package:pdfriend/play/PlayWithPDf.dart';
import 'package:pdfriend/share/screens/DocumentShare.dart';
import 'package:pdfriend/share/screens/Receiver.dart';
import 'package:pdfriend/share/screens/Sender.dart';
import 'package:pdfriend/startup%20screens/chatpdfIntro.dart';
import 'package:pdfriend/startup%20screens/playScreen.dart';
import 'package:pdfriend/startup%20screens/sharingIntro.dart';
import 'chat/screens/chat.dart';
import 'chat/screens/upload_pdf.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case UploadPDF.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UploadPDF(),
      );

    case ChatPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  ChatPage(),
      );

    case Documentshare.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  Documentshare(),
      );

    case SendingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  SendingScreen(),
      );

    case ReceivingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  ReceivingScreen(),
      );

    case PlayWithPdf.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  PlayWithPdf(),
      );

    case ChatPDFIntro.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  ChatPDFIntro(),
      );

    case Sharingintro.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  Sharingintro(),
      );

    case PlayIntro.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  PlayIntro(),
      );

    case RealHome.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  RealHome(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
