import 'dart:io';

import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AddChatPage extends StatefulWidget {
  const AddChatPage({super.key});

  @override
  State<AddChatPage> createState() => _AddChatPageState();
}

class _AddChatPageState extends State<AddChatPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final String customId = DateTime.now().millisecondsSinceEpoch.toString();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppUi.backgroundDark,
        title: Text(
          'Add Chat',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 300.0, bottom: 5),
                child: Text(
                  'Title:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                width: 350,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppUi.grey.withValues(alpha: .2),
                ),
                child: CupertinoTextField(
                  controller: _titleController,
                  placeholder: 'Title',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 270.0, bottom: 5),
                child: Text(
                  'Content:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                width: 350,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppUi.grey.withValues(alpha: .2),
                ),
                child: CupertinoTextField(
                  controller: _contentController,
                  placeholder: 'Content',
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ),
              const SizedBox(height: 20),
              if (_selectedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(_selectedImages[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: AppUi.error),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 197.0),
                child: InkWell(
                  onTap: _pickImages,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Replace Add Photos button
                        Button(
                          height: 45,
                          width: 150,
                          color: AppUi.grey.withOpacity(0.1),
                          onTap: _pickImages,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, color: AppUi.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Add Photos',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 197.0),
                child: Center(
                  child: InkWell(
                    child: Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppUi.primary
                      ),
                      child: Center(
                        child: Text(
                          'Submit Post',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppUi.backgroundDark
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      String uid = context.read<UserProvider>().currentUser.id;
                
                      PostData post = PostData();
                      post.comments = [];
                      post.description = _contentController.text;
                      post.title = _titleController.text;
                      post.date = DateTime.now().millisecondsSinceEpoch;
                      post.id = customId;
                      post.likes = [];
                      post.pics = [];
                      post.type = 'math';
                      post.uid = uid;
                      post.user = context.read<UserProvider>().currentUser;
                
                      // Add the post with images
                      context.read<UserProvider>().addPost(post, _selectedImages);
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}