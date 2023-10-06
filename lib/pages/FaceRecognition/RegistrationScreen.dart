import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../HomeLandingPage.dart';
import 'HomeScreen.dart';
import 'ML/Recognition.dart';
import 'ML/Recognizer.dart';
import 'RecognitionScreen.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {

  final firestore = FirebaseFirestore.instance;

  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;
  var image;
  List<Face> faces = [];
  //TODO declare detector
  dynamic faceDetector;

  //TODO declare face recognizer
  late Recognizer _recognizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();

    //TODO initialize detector
    final options = FaceDetectorOptions(
        enableClassification: false,
        enableContours: false,
        enableLandmarks: false);

    //TODO initialize face detector
    faceDetector = FaceDetector(options: options);

    //TODO initialize face recognizer
    _recognizer = Recognizer();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }


  //TODO face detection code here
  TextEditingController textEditingController = TextEditingController();
  doFaceDetection() async {
    faces.clear();

    //TODO remove rotation of camera images
    _image = await removeRotation(_image!);
    print('do face detection image');
    print(_image);
    //TODO passing input to face detector and getting detected faces
    final inputImage = InputImage.fromFile(_image!);
    print('input image');
    print(inputImage);
    faces = await faceDetector.processImage(inputImage);
    print('after process image');
    print(faces.length);
    //TODO call the method to perform face recognition on detected faces
    performFaceRecognition();
  }

  Future<void> insertUserIntoCloudFirestoreCollection(CollectionReference collectionReference, FaceDet user) async {
    await collectionReference.doc(user.id).set(user.toMap());
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  Future<void> requestStoragePermission(String filePath) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  //TODO perform Face Recognition
  performFaceRecognition() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");

    //insertData(bytes, '', '', '');

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left<0?0:faceRect.left;
      num top = faceRect.top<0?0:faceRect.top;
      num right = faceRect.right>image.width?image.width-1:faceRect.right;
      num bottom = faceRect.bottom>image.height?image.height-1:faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      File cropedFace = await FlutterNativeImage.cropImage(
          _image!.path,
          left.toInt(),top.toInt(),width.toInt(),height.toInt());
      final bytes = await File(cropedFace!.path).readAsBytes();
      //Save the bytes in cloud

      final img.Image? faceImg = img.decodeImage(bytes);
      Recognition recognition = _recognizer.recognize(faceImg!, face.boundingBox);

      //TODO show face registration dialogue
      showFaceRegistrationDialogue(cropedFace, recognition);
    }
    drawRectangleAroundFaces();
  }

  bool validateFaceId(String faceId) {
    // Replace this with your actual Face ID validation logic - DB
    return faceId == "sample_face_id";
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

  Future<String> fetchFaceDetRecord(String faceId) async {
    // Get a reference to the FaceDet collection
    CollectionReference faceDetCollection =
    FirebaseFirestore.instance.collection('FaceDet');

    try {
      // Query the collection using the given faceId
      QuerySnapshot querySnapshot =
      await faceDetCollection.where('faceId', isEqualTo: faceId).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isEmpty) {
        // If no documents match the query, return the message
        return 'faceId not available in DB';
      } else {
        // If a matching document is found, return the document data (or do something with it)
        // In this example, we return the first document's data as a JSON string
        return querySnapshot.docs.first.data().toString();
      }
    } catch (e) {
      // Handle any errors that occur during the fetch process
      print('Error fetching record: $e');
      return 'Error fetching record';
    }
  }

  void _login(BuildContext context, String faceId) async {
    String recordData = await fetchFaceDetRecord(faceId);

    if (recordData == 'faceId not available in DB') {
      // Show an error dialog if the faceId is not available in the database
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
          Text('Face ID not available in the database. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Navigate to the landing page if the faceId is valid
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeLandingPage()),
      );
    }
  }
  //TODO Face Registration Dialogue
  showFaceRegistrationDialogue(File cropedFace, Recognition recognition){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration",textAlign: TextAlign.center),alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Image.file(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration( fillColor: Colors.white, filled: true,hintText: "Enter Name")
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () {
                    HomeScreen.registered.putIfAbsent(
                        textEditingController.text, () => recognition);
                    textEditingController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },style: ElevatedButton.styleFrom(primary:Colors.blue,minimumSize: const Size(200,40)),
                  child: const Text("Register"))
            ],

          ),
        ),contentPadding: EdgeInsets.zero,
      ),
    );
  }

  //TODO draw rectangles
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    print('drawRectangleAroundFaces : ');
    setState(() {
      image;
      faces;
    });
    insertData(image, 'email', 'mobile', 'name');
  }

  void insertData(Uint8List imageBytes, String email, String mobile, String name) async {
    // Convert the image to bytes (replace with your image data)
    //List<int> imageBytes = [/* Your image bytes here */];
    final firestore = FirebaseFirestore.instance;
    final collectionReference = firestore.collection('FaceDet');

    String faceId = generateRandomTenDigitNumber();
    // Create a FaceDet object with the data
    FaceDet faceDet = FaceDet(
      createdDtTime: Timestamp.now(), // Replace with your date
      email: email,
      faceId: faceId, //Generated 10 digit number
      faceImageBytes: imageBytes,
      id: faceId,    //Generated 10 digit number
      isBlocked: 'N',
      mobile: mobile,
      name: name,
    );

    // Add the data to the Firestore collection
    //await firestore.collection('FaceDet').add(faceDet.toMap());
    await insertUserIntoCloudFirestoreCollection(collectionReference, faceDet);

    print('Data added to Firestore');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    TextEditingController nameController = TextEditingController(); // Create a TextEditingController for the Name input

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ? Container(
            margin: const EdgeInsets.only(
                top: 10, left: 30, right: 30, bottom: 0),
            child: FittedBox(
              child: SizedBox(
                width: image.width.toDouble(),
                height: image.width.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(
                      facesList: faces, imageFile: image),
                ),
              ),
            ),
          )
              : Container(
            margin: const EdgeInsets.only(top: 10),
            child: Image.asset(
              "images/logo.png",
              width: screenWidth - 100,
              height: screenWidth - 100,
            ),
          ),

          Container(
            height: 50,
          ),
          // Add the 'Name' input field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Add the 'Sign-up' ElevatedButton
          ElevatedButton(
            onPressed: () {
              // Implement the Sign-up logic here
              String name = nameController.text; // Get the entered name

              // You can use the 'name' variable for further processing
              print("name : "+name);
             //_login(context, name);
            },
            child: Text('Sign-up'),
          ),
          // Section which displays buttons for choosing and capturing images
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.image,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.camera,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }

    Paint p2 = Paint();
    p2.color = Colors.green;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 3;

    Paint p3 = Paint();
    p3.color = Colors.yellow;
    p3.style = PaintingStyle.stroke;
    p3.strokeWidth = 1;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FaceDet {
  final Timestamp createdDtTime;
  final String email;
  final String faceId;
  final Uint8List faceImageBytes; // Store image as bytes
  final String id;
  final String isBlocked;
  final String mobile;
  final String name;
  final String userStatus;

  FaceDet({
    required this.createdDtTime,
    required this.email,
    required this.faceId,
    required this.faceImageBytes,
    required this.id,
    required this.isBlocked,
    required this.mobile,
    required this.name,
    this.userStatus = 'A', // Default value for userStatus
  });

  // Convert the object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'createdDtTime': createdDtTime,
      'email': email,
      'faceId': faceId,
      'faceImage': faceImageBytes,
      'id': id,
      'isBlocked': isBlocked,
      'mobile': mobile,
      'name': name,
      'userStatus': userStatus,
    };
  }
}