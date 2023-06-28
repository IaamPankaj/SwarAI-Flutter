import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class AudioUploaderScreen extends StatefulWidget {
  @override
  _AudioUploaderScreenState createState() => _AudioUploaderScreenState();
}

class _AudioUploaderScreenState extends State<AudioUploaderScreen> {
  File? _selectedFile;

  Future<void> _selectFile() async {
    print("11111");
    final result = await FilePicker.platform.pickFiles();

    if (result == null) {
      // User canceled the picker
      return;
    }

    setState(() {
      _selectedFile = File(result.files.single.path!);
    });
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      // No file selected
      return;
    }

    // Replace this URL with your own API endpoint that accepts file uploads.
    final uploadUrl = Uri.parse('https://example.com/upload');

    // Create a multipart request to upload the file.
    final request = http.MultipartRequest('POST', uploadUrl);

    // Add the file to the request.
    final filePart = await http.MultipartFile.fromPath('file', _selectedFile!.path);
    request.files.add(filePart);

    // Send the request.
    final response = await request.send();

    // Check the response status code to see if the file was successfully uploaded.
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('File uploaded'),
          content: Text('The file was successfully uploaded.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error uploading file'),
          content: Text('There was an error uploading the file.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedFile == null)
              Text('No file selected')
            else
              Text(_selectedFile!.path),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: _selectFile,
              child: Text('Choose Audio'),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: _uploadFile,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
