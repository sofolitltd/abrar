import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class OCR extends StatefulWidget {
  const OCR({super.key});

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  File? _imageFile;
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false; // Add a loading state

  //
  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
          _isLoading = true;
          _textController.clear();
        });
        _extractPhoneNumber();
      }
    }
  }

  //
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
            if (line.text.startsWith('88')) {
              setState(() {
                _textController.text = line.text.substring(2);
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
        title: const Text('Number Scanner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            Stack(
              alignment: Alignment.center,
              children: [
                //
                Stack(
                  alignment: Alignment.center,
                  children: [
                    //
                    Container(
                      height: 200,
                      width: double.maxFinite,
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      child:
                          _imageFile != null ? Image.file(_imageFile!) : null,
                    ),

                    //
                  ],
                ),

                if (_isLoading) // Show loading indicator
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            //
            Container(
              padding: const EdgeInsets.all(16),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _captureImage,
                child: const Text('Scan Mobile Number'),
              ),
            ),

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

//
// class OCR2 extends StatefulWidget {
//   const OCR2({super.key});
//
//   @override
//   State<OCR2> createState() => _OCR2State();
// }
//
// class _OCR2State extends State<OCR2> {
//   late CameraController _controller;
//   late Future<void> _initializeCameraControllerFuture;
//   List<CameraDescription> _cameras = [];
//   File? _capturedImage; // To store the captured image
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     final firstCamera = _cameras.first;
//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//     );
//     _initializeCameraControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Capture Image'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               //
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black12),
//                   ),
//                   child: ClipRRect(
//                     child: FutureBuilder<void>(
//                       future: _initializeCameraControllerFuture,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           // Camera is initialized, you can safely use _controller here
//                           return CameraPreview(_controller);
//                         } else {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Display captured image
//               if (_capturedImage != null)
//                 Image.file(_capturedImage!, height: 200),
//
//               const SizedBox(height: 16),
//
//               //
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_controller.value.isInitialized) {
//                     final image = await _controller.takePicture();
//                     setState(() {
//                       _capturedImage = File(image.path);
//                     });
//                   } else {
//                     print('Camera is not initialized yet');
//                   }
//                 },
//                 child: const Text('Scan Image'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
