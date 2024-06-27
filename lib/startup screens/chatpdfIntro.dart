import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPDFIntro extends StatelessWidget {
  const ChatPDFIntro({super.key});
  static const String routeName = '/chat-pdf-intro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDFriend'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top section with the image and fade effect
          Expanded(
            flex: 5, // Increased flex value
            child: Stack(
              children: [
                // The image
                Image.asset(
                  'assets/images/1.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // The gradient to fade the bottom of the image
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     height: 180.0,
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           Colors.white10,
                //           Colors.white,
                //           Color.fromRGBO(252, 246, 253, 1),
                //         ],
                //         stops: [0.6, 1], // Adjust stops to make gradient stronger
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // Bottom section with other content
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chat with all your PDF\nquickly and easily',
                    textAlign: TextAlign.center, // Center-align the text
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Going through your documents is time consuming? \nUnleash the power of AI & get instant answers',
                    textAlign: TextAlign.center, // Center-align the text
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space the buttons evenly
              children: [
                SizedBox(
                  width: 150, // Adjust the width of the button
                  height: 50,  // Adjust the height of the button
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>( Color.fromRGBO(236, 229, 255, 1.0)),
                  ),
                    child: Text('Skip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Increase text size
                  ),
                ),
                SizedBox(
                  width: 150, // Adjust the width of the button
                  height: 50,  // Adjust the height of the button
                  child: ElevatedButton(
                    onPressed: ()=> Navigator.of(context).pushNamed('/sharing-intro'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurple),
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text('Next', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Increase text size
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
