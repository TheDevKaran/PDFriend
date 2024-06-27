import 'package:flutter/material.dart';

class Documentshare extends StatelessWidget {
  static const String routeName = '/document-share';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Text('Document Share',),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sender');
              },
              child: Text('Send Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/receiver');
              },
              child: Text('Receive Text'),
            ),
          ],
        ),
      ),
    );
  }
}