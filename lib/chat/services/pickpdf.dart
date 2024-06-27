import 'package:file_picker/file_picker.dart';

Future<String?> pickPdfFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.single.path != null) {
    return result.files.single.path!;
  }
  return null;
}
