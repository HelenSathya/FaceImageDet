import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//void main() {
  //runApp(MyApp());
//}

//class MyApp extends StatelessWidget {
  //@override
  //Widget build(BuildContext context) {
    //return MaterialApp(
      //home: MyHomePage(),
    //);
  //}
//}

class MyImagePickerPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyImagePickerPage> {
  File? _imageFile;File? _readFile;
  Uint8List? _imageBytes;
  String? savedImagePath;

  // Function to pick an image from the device's gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _imageFile = File(pickedImage.path);
    });
  }

  // Function to save the image to a folder and convert it to Uint8List
  Future<void> _saveAndConvertToUint8List() async {
    if (_imageFile == null) {
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/images');

    if (!imageDir.existsSync()) {
      imageDir.createSync(recursive: true);
    }

    savedImagePath = '${imageDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _imageFile?.copy(savedImagePath!);

    //readFileFromAppFlutter(savedImagePath);

    setState(() {
      _imageBytes = File(savedImagePath!).readAsBytesSync();
    });

    print('Image saved to: $savedImagePath');

    //readFileFromAppFlutter(savedImagePath);
    final _readFile = File(savedImagePath!);
    if (_readFile.existsSync()) {
      final fileContent = await _readFile.readAsBytesSync();
      print('File content: $fileContent');
    } else {
      print('File does not exist.');
    }
  }

  Future<void> readFileFromAppFlutter() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/images');
    savedImagePath = '${imageDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final _readFile = File(savedImagePath!);
    if (_readFile.existsSync()) {
      final fileContent = await _readFile.readAsBytesSync();
      print('File content: $fileContent');
    } else {
      print('File does not exist.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save and Convert Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAndConvertToUint8List,
              child: Text('Save and Convert to Uint8List'),
            ),
            SizedBox(height: 20),
            _imageBytes != null
                ? Text('Uint8List Length: ${_imageBytes?.length}')
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: readFileFromAppFlutter,
              child: Text('Save and Convert to Uint8List'),
            ),
            SizedBox(height: 20),
            _readFile != null
                ? Image.file(
              _readFile!,
              height: 200,
            )
                : Text('No image read from file'),
          ],
        ),
      ),
    );
  }
}
