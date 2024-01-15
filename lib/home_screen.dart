import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:take_picture_app/Colors.dart' as c;

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _image;
  final picker = ImagePicker();
  // int _imageQuality = 100;

  Future getImageFromGallery() async {
    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);

    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    // final kb = bytes / 1024;
    // final mb = kb / 1024;

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);

    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    // final kb = bytes / 1024;
    // final mb = kb / 1024;

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_image == null) return;
    final fileName = basename(_image!.path);
    final destination = 'files/$fileName';

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(_image!);
    } catch (e) {
      print('error occured');
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: this.context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Image Picker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              child: Text('Pilih Gambar'),
              onPressed: showOptions,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Ukuran maximal file adalah 200kb',
                style: TextStyle(color: c.redColor),
              ),
            ),
            Center(
              child: _image == null
                  ? Text('Tidak ada gambar yang dipilih')
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_image!.path),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
