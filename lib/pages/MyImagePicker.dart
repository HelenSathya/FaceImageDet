import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:googleapis/compute/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upi_pay_app/DataBase/FaceImgDet.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as SQL;

class MyImagePicker extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyImagePicker> {
  File? _imageFile;
  File? _readImageFile;
  Uint8List? _imageBytes;
  late SQL.Database handler;
  File? _readScannedImageFile;
  File? _readMatchedImageFile;

  Future<String> saveImageToImagesFolder(File imageFile) async {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');

      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }

      final fileName = 'my_image.jpg';
      final imagePath = '${imagesDir.path}/$fileName';

      await imageFile.copy(imagePath);

      // You can return the imagePath or use it as needed
      return imagePath;
  }

	Future<File> readImageFromImagesFolder() async {

    fetchImageDetails();

	  final appDir = await getApplicationDocumentsDirectory();
	  final imagePath = '${appDir.path}/images/my_image.jpg';
	  final imageFile = File(imagePath);

	  if (imageFile.existsSync()) {
		return imageFile;
	  } else {
		throw Exception('Image file does not exist.');
	  }
	}

  encodeToBase64ImageAndInsert(Uint8List imageBytes) {
    String base64Image = base64Encode(imageBytes);
    FirebaseFirestore.instance.collection('ImageDet').add({
      'imageBase64': base64Image,
    });
  }

  fetchImageDetails() {
    //final docRef = FirebaseFirestore.instance.collection("ImageDet").doc("SF");
    final docRef = FirebaseFirestore.instance.collection('ImageDet').doc();
    docRef.get().then(
        (DocumentSnapshot doc) async {
          final Map<String, dynamic>? data = doc?.data() as Map<
              String,
              dynamic>?;

          if (data != null) {
            final String? base64Image = data['imageBase64'] as String?;
            if (base64Image != null) {
              // Convert to image and set it into the container
              Uint8List imageBytes = base64Decode(base64Image);

              //final String filePath = '/path/to/save/image.png'; // Replace with your desired file path
              //final File? imageFile = convertImageBytesToFile(imageBytes, filePath) as File?;

              final appDir = await getApplicationDocumentsDirectory();
              final imagesDir = Directory('${appDir.path}/images');

              if (!imagesDir.existsSync()) {
                imagesDir.createSync(recursive: true);
              }

              final fileName = 'my_image.jpg';
              final imagePath = '${imagesDir.path}/$fileName';

              //final String filePath = '/path/to/save/image.png'; // Replace with your desired file path

              final File? imageFile = convertImageBytesToFile(imageBytes, imagePath) as File?;
              //saveImageToImagesFolder(imageFile!);

              if (imageFile != null) {
                print('Image file saved successfully: ${imageFile.path}');
              } else {
                print('Error saving image file.');
              }

            } else {
              // Handle the case where 'imageBase64' is null
            }
          } else {
            // Handle the case where data is null
          }
        });
  }

  Future<File?> convertImageBytesToFile(Uint8List imageBytes, String filePath) async {
    try {
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      return file;
    } catch (e) {
      print('Error converting image bytes to file: $e');
      return null;
    }
  }

  Future<void> _pickAndSaveImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    final imageFile = File(pickedImage.path);
    try {
      await saveImageToImagesFolder(imageFile);
      String tenDigitNo = generateRandomTenDigitNumber();
      print('Ten Digit no');print(tenDigitNo);
      saveImageToFirestore(imageFile, tenDigitNo);
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  String generateRandomTenDigitNumber() {
    Random random = Random();

    // Generate a positive random integer within the valid range
    int min = 1; // Minimum value (inclusive)
    int max = 4294967295; // Maximum value (inclusive, 2^32 - 1)
    int randomNumber = min + random.nextInt(max - min + 1);

    // Print the generated random integer
    print("Generated random integer: $randomNumber");
    return randomNumber.toString();
  }

  Future<void> _loadImageFromImagesFolder() async {
    try {
      final imageFile = await readImageFromImagesFolder();
      //Read A
      setState(() {
        _readImageFile = imageFile;
      });
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  Future<void> storeImageUrlInFirestore(String imageUrl) async {
    try {
      final CollectionReference imageDetCollection = FirebaseFirestore.instance.collection('ImageDet');
      await imageDetCollection.add({
        'imageUrl': imageUrl,
      });
      print('Image URL stored in Firestore.');
    } catch (e) {
      print('Error storing image URL in Firestore: $e');
    }
  }

  Future<void> saveImageToFirestore(File imageFile, String faceId) async {
    try {
      //encodeToBase64ImageAndInsert(imageBytes);
      final imageBytes = await imageFile.readAsBytes();
      String base64Image = await compressBase64Image(imageBytes);
      //compressBase64Image(base64Image);
      //FaceImgDet faceImgDt =
      //FaceImgDet(faceId: faceId, name: "Mercury", base64Str: base64Image);
      //List<FaceImgDet> planets = [faceImgDt];
      //await handler.insert(planets);
      //final Uint8List imageBytes = await compressWithList;
      //final String compressedBase64Image = base64Encode(imageBytes);

      print(base64Image);print(faceId);
      final docRef = FirebaseFirestore.instance.collection('ImageDet').doc();
      if (docRef != null) {
        await docRef.set({
          'imageBase64': base64Image,
          'faceId': faceId,
        });
      } else {
        print('Doc Ref is null...');
      }
      print('Image and face ID saved to Firestore');
    } catch (e) {
      print('Error saving image and face ID: $e');
    }
  }

  Future<String> compressBase64Image(Uint8List base64Image) async {
    try {
      // Decode the Base64-encoded image to Uint8List
      //final Uint8List uint8List = base64Decode(base64Image);

      // Compress the image using flutter_image_compress
     Future<Uint8List> compressWithList = FlutterImageCompress.compressWithList(
       base64Image,
        minHeight: 100, // Set your desired minimum height
        minWidth: 100,  // Set your desired minimum width
        quality: 85,    // Set the image quality (0-100, 85 is a good default)
      );

      //Encode the compressed data back to Base64
      final Uint8List imageBytes = await compressWithList;
      final String compressedBase64Image = base64Encode(imageBytes);

      //final String compressedBase64 = base64.encode(compressWithList);
      return compressedBase64Image;
    } catch (e) {
      print('Error compressing Base64 image: $e');
      return "null";
    }
  }

  Future<Uint8List?> getImageFromFirestore(String documentId) async {
    try {
      final docSnapshot =
      await FirebaseFirestore.instance.collection('ImageDet').doc(documentId).get();

      if (docSnapshot.exists) {
        final imageBytes = docSnapshot.data()?['imageBytes'];
        return Uint8List.fromList(List.from(imageBytes));
      } else {
        print('Document not found in Firestore');
        return null;
      }
    } catch (e) {
      print('Error fetching image from Firestore: $e');
      return null;
    }
  }

  /**
   * Fetch all details from the 'ImageDet' Cloud Firestore collection.
   *
   */
  Future<List<Map<String, dynamic>>> getAllImageDetData() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ImageDet')
        .get();

    final List<Map<String, dynamic>> imageDetList = querySnapshot.docs
        .map((DocumentSnapshot documentSnapshot) =>
    documentSnapshot.data() as Map<String, dynamic>)
        .toList();

    return imageDetList;
  }

  /**
   *
   * Compare the base64Image string to scanned base64ImageString.
   *
   */
  Future<int> compareImages(String scannedImageBase64) async {
    final List<Map<String, dynamic>> imageDetList = await getAllImageDetData();
    //final String scannedImageBase64 = '...'; // Replace with your scanned image's Base64 string.
    int matchFound = 0;
    for (final imageDet in imageDetList) {
      final String base64Image = imageDet['base64Image'];

      if (scannedImageBase64 == base64Image) {
        // Match found, you can access other fields in 'imageDet' if needed.
        matchFound = 1;
        print('Match found: $base64Image');
      } else {
        print('Match not found:');
      }
    }
    return matchFound;
  }

  Future<void> _loadImageFromScanOrDB() async {
    try {
      //final imageFile = await readImageFromImagesFolder();
      final List<Map<String, dynamic>> allImgDetails = await getAllImageDetData();
      print("1");
      //Scan the image and convert it into base64ImageString
      final scannedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (scannedImage == null) {
        return;
      }
      final scannedImageFile = File(scannedImage.path);
      print("2");
      final imageBytes = await scannedImageFile.readAsBytes();
      String scannedImageBase64 = await compressBase64Image(imageBytes);
      print("3");
      //int matchFound = compareImages(scannedImageBase64);
      int matchFound = 0;String base64ImageFromDB = "";
      //Compare the base64Image string to scanned base64ImageString.
      for (final imageDet in allImgDetails) {
        base64ImageFromDB = imageDet['base64Image'];
        print("4");
        if (scannedImageBase64 == base64ImageFromDB) {
          // Match found, you can access other fields in 'imageDet' if needed.
          matchFound = 1;
          //ConvertBase64Image string to ImageFile
          print('Match found: $base64ImageFromDB');
        } else {
          print('Match not found:');
        }
        print("5");
      }
      if (matchFound == 1) {

        //ConvertBase64Image string to ImageFile
        Uint8List imageBytes = base64Decode(base64ImageFromDB);
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory('${appDir.path}/images');
        final fileName = 'my_image.jpg';
        final imagePath = '${imagesDir.path}/$fileName';
        print("6");
        final File? matchedImageFile = convertImageBytesToFile(imageBytes, imagePath) as File?;

        if (matchedImageFile != null) {
          print('Image file saved successfully: ${matchedImageFile.path}');
        } else {
          print('Error saving image file.');
        }print("7");
        //Load both scanned and matched image from DB
        setState(() {
          _readScannedImageFile = scannedImageFile;
          _readMatchedImageFile = matchedImageFile;
        });
      }

    } catch (e) {
      print('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image File Operations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndSaveImage,
              child: Text('Pick and Save Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              //onPressed: _loadImageFromImagesFolder,
              onPressed: _loadImageFromScanOrDB,
              child: Text('Load Image from Folder'),
            ),
            SizedBox(height: 20),
            if (_readScannedImageFile != null)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_readScannedImageFile!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Text('No image selected in scan'),
            SizedBox(height: 20),
            if (_readMatchedImageFile != null)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_readMatchedImageFile!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Text('No matched image'),
          ],
        ),
      ),
    );
  }
}
