import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class PhoneExtractorPage extends StatefulWidget {
  const PhoneExtractorPage({super.key});

  @override
  State<PhoneExtractorPage> createState() => _PhoneExtractorPageState();
}

class _PhoneExtractorPageState extends State<PhoneExtractorPage> {
  File? _imageFile;
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false; // Add a loading state

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isLoading = true;
        _textController.clear();
      });
      _extractPhoneNumber();
    }
  }

  Future<void> _extractPhoneNumber() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(_imageFile!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Simple regex to find a phone number (customize as needed)
    RegExp phoneRegex = RegExp(r'\d{10}'); // Example for 10-digit numbers

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (phoneRegex.hasMatch(line.text)) {
          //
          if (line.text.isNotEmpty) {
            if (line.text.startsWith('88') || !line.text.startsWith('0')) {
              setState(() {
                _textController.text = line.text.substring(2);
              });
            }
            if (!line.text.startsWith('0')) {
              setState(() {
                _textController.text = line.text;
              });
            } else {
              _textController.text = line.text;
            }
          }
        }
      }
    }
    textRecognizer.close();
    setState(() {
      _isLoading = false; // Stop loading after extraction
    });
  }

  void _copyToClipboard() {
    if (_textController.text.trim().isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _textController.text.trim()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Copied number: ${_textController.text.trim()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Extractor'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            if (_imageFile != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(
                    _imageFile!,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                  if (_isLoading) // Show loading indicator
                    const SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator()),
                ],
              ),
            const SizedBox(height: 20),

            //
            ElevatedButton(
              onPressed: _captureImage,
              child: const Text('Capture Image'),
            ),
            const SizedBox(height: 20),

            //
            // if (_extractedPhoneNumber.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  //
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),

                  //
                  const SizedBox(width: 12),

                  //
                  ElevatedButton(
                    onPressed: _copyToClipboard,
                    child: const Text('Copy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
