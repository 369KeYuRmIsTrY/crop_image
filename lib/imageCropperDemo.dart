import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCropperDemo extends StatefulWidget {
  @override
  _ImageCropperDemoState createState() => _ImageCropperDemoState();
}

class _ImageCropperDemoState extends State<ImageCropperDemo> {
  File? _croppedFile;

  Future<void> _pickAndCropImage() async {
    // Step 1: Pick image
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    // Step 2: Crop image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (croppedFile == null) return;

    // Step 3: Save cropped image to internal storage
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = p.join(
      directory.path,
      'cropped_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    final File savedImage = await File(croppedFile.path).copy(newPath);

    setState(() {
      _croppedFile = savedImage;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cropped image saved to internal storage!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker & Cropper'),
        backgroundColor: Colors.blue,
        elevation: 4,
        foregroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset('assets/app_icon.png'),
        ),
      ),
      body: Center(
        child: _croppedFile == null
            ? Text('No image selected.')
            : Image.file(_croppedFile!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndCropImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
