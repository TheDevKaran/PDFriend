// import 'package:flutter/material.dart';
//
// class RealHome extends StatelessWidget {
//   const RealHome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(onPressed: ()=> Navigator.of(context).pushNamed('/home'), child: Text('Chat with PDF')),
//           ElevatedButton(onPressed: ()=> Navigator.of(context).pushNamed('/document-share'), child: Text('Document Share')),
//           ElevatedButton(onPressed: ()=> Navigator.of(context).pushNamed('/play-with-pdf'), child: Text('Document Resixer')),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class RealHome extends StatelessWidget {
  const RealHome({super.key});
  static const String routeName = '/real-home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Center(
            child: Image.asset(
              'assets/images/Design.png', // Replace with your image asset
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Centered container to hold content
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 490), // Adjust padding as needed
              child: Column(
                children: [
                  SizedBox(
                    width: 308, // Adjust button width as needed
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed('/home'),
                      child: Text('Chat with PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(235, 237, 237, 1.0),
                        )
                      ),
                  ),
                  SizedBox(height: 49),
                  SizedBox(
                    width: 308,height: 35, // Adjust button width as needed
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed('/document-share'),
                      child: Text('Document Share', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(235, 237, 237, 1.0),
                        )
                    ),
                  ),
                  SizedBox(height: 47),
                  SizedBox(
                    width: 308, height: 35,// Adjust button width as needed
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed('/play-with-pdf'),
                      child: Text('Document Resizer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(235, 237, 237, 1.0),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
