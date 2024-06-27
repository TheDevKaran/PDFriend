import 'dart:io';

// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PlayWithPdf extends StatefulWidget {
  static const String routeName = '/play-with-pdf';

  @override
  _PlayWithPdfState createState() => _PlayWithPdfState();
}

class _PlayWithPdfState extends State<PlayWithPdf> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image to PDF"),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              createPDF();
              savePDF();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImageFromGallery,
      ),
      body: _images.isNotEmpty
          ? ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) => Container(
          height: 400,
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: Image.file(
            _images[index],
            fit: BoxFit.cover,
          ),
        ),
      )
          : Center(child: Text('No images selected')),
    );
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Future<void> createPDF() async {
    for (var img in _images) {
      final image = pw.MemoryImage(img.readAsBytesSync());
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          },
        ),
      );
    }
  }

  Future<void> savePDF() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final file = File('${directory.path}/filename.pdf');
        await file.writeAsBytes(await pdf.save());
        // showS('Success', 'Saved to ${directory.path}/filename.pdf');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to ${directory.path}/filename.pdf')),
        );
      } else {
        // showPrintedMessage('Error', 'Could not access storage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Could not access storage')),
        );
      }
    } catch (e) {
      // showPrintedMessage('Error', e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error $e',)),
      );
    }
  }


}
