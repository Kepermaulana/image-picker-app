import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:take_picture_app/Colors.dart' as c;
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:take_picture_app/widgets/WAlertDIalog.dart';
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

  Future getImageFromGallery() async {
    // var maxFileSizeInBytes = 0.2 *
    //     1048576; // 5MB (You'll probably want this outside of this function so you can reuse the value elsewhere)

    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 960,
      maxHeight: 720,
    );

    final decodedImage =
        await decodeImageFromList(await pickedFile!.readAsBytes());

    int sizeinkb = 200000;
    final bytes = (await pickedFile.readAsBytes()).lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    setState(() {
      if (pickedFile != null && bytes >= sizeinkb) {
        // _image = newImage;

        // showDialog(
        //   barrierColor: Colors.black26,
        //   context: context,
        //   builder: (context) {
        //     return WDialog_TextAlert(context, 'Upload Gambar Gagal', '');
        //   },
        // );

        ScaffoldMessenger.of(context).showSnackBar(
            WSnackBar_TextAlert(context, 'File size is $bytes KB', ''));

        print("error File Size is: $bytes");
        print('No image selected.');
      } else {
        _image = File(pickedFile.path);
        GallerySaver.saveImage(pickedFile.path);
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return WDialog_TextAlert(context, 'Upload Gambar Berhasil', '');
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
            WSnackBar_TextAlert(context, 'File size is $bytes KB', ''));

        uploadFile();
        print("File Size is: $bytes KB");
        print(decodedImage.width);
        print(decodedImage.height);
      }
    });
  } 

  Future getImageFromCamera() async {
    // final bytes = (await _image!.readAsBytes()).lengthInBytes;
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxWidth: 720,
      maxHeight: 960,
    );
    // File file = new File("/data/user/0/com.example.take_picture_app/cache/");

    // String fileName = file.path.split('/').last;

    // print("FileName: $fileName");

    final decodedImage =
        await decodeImageFromList(await pickedFile!.readAsBytes());

    int sizeinkb = 200000;
    final bytes = (await pickedFile.readAsBytes()).lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    setState(() {
      if (pickedFile != null && bytes >= sizeinkb) {
        // _image = File(pickedFile!.path);
        // GallerySaver.saveImage(pickedFile.path);
        // uploadFile();
        // showDialog(
        //   barrierColor: Colors.black26,
        //   context: context,
        //   builder: (context) {
        //     return WDialog_TextAlert(context, 'Upload Gambar Gagal', '');
        //   },
        // );

        ScaffoldMessenger.of(context).showSnackBar(
            WSnackBar_TextAlert(context, 'File size is $bytes KB', ''));

        print("error: File Size is: $bytes KB");
      } else {
        _image = File(pickedFile.path);
        GallerySaver.saveImage(pickedFile.path);
        uploadFile();
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return WDialog_TextAlert(context, 'Upload Gambar Berhasil',
                'Silahkan cek di folder penyimpanan anda');
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
            WSnackBar_TextAlert(context, 'File size is $bytes KB', ''));
        // print('No image selected.');
        print("File Size is: $bytes KB");
        print(decodedImage.width);
        print(decodedImage.height);
      }
    });
  }

  Future uploadFile() async {
    if (_image == null) return;
    final fileName = Path.basename(_image!.path);
    final destination = 'files/$fileName';

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(
        _image!,
        SettableMetadata(
          contentType: "image/jpg",
        ),
      );
    } catch (e) {
      print('error occured');
    }
  }

  Future<int> getImageFileSize() async {
    int sizeinkb = 200;
    final bytes = (await _image!.readAsBytes()).lengthInBytes;
    // int fileSize = _image!.lengthSync().bitLength;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    setState(() {
      if (bytes >= sizeinkb) {
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return WDialog_TextAlert(context, 'Upload Gambar Gagal',
                'Ukuran File lebih dari 200kb ');
          },
        );
      }
    });

    // print("File Size is: $fileSize");
    print("File Size is: $bytes");
    return bytes;
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
              // getImageGalerry();
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
                              File(
                                _image!.path,
                              ),
                              
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // saveImage();
                        //   },
                        //   child: Text("Simpan Gambar"),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
