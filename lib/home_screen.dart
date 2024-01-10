import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:take_picture_app/Colors.dart' as c;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final picker = ImagePicker();
  // int _imageQuality = 100;

  Future getImageFromGallery() async {
    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 5);

    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    // final kb = bytes / 1024;
    // final mb = kb / 1024;

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print(_image);
      // print(bytes);
    }
  }

  Future getImageFromCamera() async {
    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 5);

    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    // final kb = bytes / 1024;
    // final mb = kb / 1024;

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print(_image);
      // print()
      // print(bytes);
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
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
                'Ukuran maximal file adalah 100kb',
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
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
