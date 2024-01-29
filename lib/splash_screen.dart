// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           color: Colors.white,
//           child: Column(
//             children: <Widget>[
//               Flexible(
//                 flex: 1,
//                 child: Container(
//                   child: SizedBox.expand(
//                     child: TextButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(Colors.blue),
//                       ),
//                       onPressed: _takePhoto,
//                       child: Text("firstButtonText",
//                           style: TextStyle(
//                               fontSize: 20, color: Colors.white)),
//                     ),
//                   ),
//                 ),
//               ),
//               ScreenshotWidget(),
//               Flexible(
//                 child: Container(
//                     child: SizedBox.expand(
//                   child: TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.white),
//                     ),
//                     onPressed: _recordVideo,
//                     child: Text("secondButtonText",
//                         style: TextStyle(
//                             fontSize: 20, color: Colors.blueGrey)),
//                   ),
//                 )),
//                 flex: 1,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ScreenshotWidget extends StatefulWidget {
//   @override
//   _ScreenshotWidgetState createState() => _ScreenshotWidgetState();
// }

// class _ScreenshotWidgetState extends State<ScreenshotWidget> {
//   final GlobalKey _globalKey = GlobalKey();
//   String screenshotButtonText = 'Save screenshot';

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       flex: 1,
//       child: RepaintBoundary(
//         key: _globalKey,
//         child: Container(
//           child: SizedBox.expand(
//             child: TextButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.pink),
//               ),
//               onPressed: _saveScreenshot,
//               child: Text(screenshotButtonText,
//                   style: TextStyle(fontSize: 20, color: Colors.white)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveScreenshot() async {
//     setState(() {
//       screenshotButtonText = 'saving in progress...';
//     });
//     try {
//       //extract bytes
//       final RenderObject? boundary =
//           _globalKey.currentContext?.findRenderObject();
//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final ByteData byteData =
//           await image.toByteData(format: ui.ImageByteFormat.png);
//       final Uint8List pngBytes = byteData.buffer.asUint8List();

//       //create file
//       final String dir = (await getApplicationDocumentsDirectory()).path;
//       final String fullPath = '$dir/${DateTime.now().millisecond}.png';
//       File capturedFile = File(fullPath);
//       await capturedFile.writeAsBytes(pngBytes);
//       print(capturedFile.path);

//       await GallerySaver.saveImage(capturedFile.path).then((value) {
//         setState(() {
//           screenshotButtonText = 'screenshot saved!';
//         });
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  String firstbuttontext = 'take photo';
  String secondbuttontext = 'record video';
  double textsize = 20;
  final _picker = ImagePicker();

  Future _takephoto() async {
    await _picker
        .pickImage(source: ImageSource.camera)
        .then((XFile? recordedimage) {
      if (recordedimage != null) {
        setState(() {
          firstbuttontext = 'saving in progress...';
        });
        GallerySaver.saveImage(recordedimage.path).then((path) {
          setState(() {
            firstbuttontext = 'image saved!';
          });
        });
      }
    });
  }

  Future _recordvideo() async {
    await _picker
        .pickVideo(source: ImageSource.camera)
        .then((XFile? recordedvideo) {
      if (recordedvideo != null) {
        setState(() {
          secondbuttontext = 'saving in progress...';
        });
        GallerySaver.saveVideo(recordedvideo.path).then((path) {
          setState(() {
            secondbuttontext = 'video saved!';
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: SizedBox.expand(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _takephoto();
                  },
                  child: Text("firstbuttontext",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox.expand(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text("secondbuttontext",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
