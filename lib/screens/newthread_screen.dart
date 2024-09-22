import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quickie_mobile/utils/text_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewThreadScreen extends StatefulWidget {
  const NewThreadScreen({Key? key}) : super(key: key);

  @override
  _NewThreadScreenState createState() => _NewThreadScreenState();
}

class _NewThreadScreenState extends State<NewThreadScreen> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _images.add(photo);
        });
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, 
      appBar: AppBar(
        leadingWidth: 40,
        centerTitle: false,
        elevation: 0.4,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleText(text: "New Thread", size: 20),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement post functionality
            },
            child: Text(
              'Post',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Allows scrolling when content overflows the screen
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage("assets/profiles/myprofile.png"),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 2,
                      height: 100,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(text: "dev_73arner", size: 16),
                      const SizedBox(height: 8),
                      TextField(
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: const InputDecoration(
                          hintText: "Start a thread...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_images.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: _images.map((xFile) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(xFile.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt,
                      color: Theme.of(context).primaryColor),
                  onPressed: _takePicture,
                ),
                const SizedBox(width: 16),
                Text(
                  "Add to thread",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
