import 'dart:io';

import 'package:api_php_mysql_training/app/component/costomTextform.dart';
import 'package:api_php_mysql_training/app/component/crud.dart';
import 'package:api_php_mysql_training/constant/api_links.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNote extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final String img;
  const EditNote({
    super.key,
    required this.img,
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> with Crud {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController conTitle = TextEditingController();
  TextEditingController conContent = TextEditingController();

  bool isloding = false;
  String titleHint = "Add a title";
  String contentHint = "Type the content";
  Future deleteOldImage() async {
    var response = await postRequest(oldImage, {"imgName": widget.img});
    print(
      "old imag supposesed to be deleted ,response: ============>$response",
    );
  }

  Future editNote() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloding = true;
      });
      var response;
      if (myImg == null) {
        response = await postRequest(editLink, {
          "note_title": conTitle.text,
          "note_content": conContent.text,
          "id": widget.id.toString(),
        });
      } else {
        await deleteOldImage();
        response = await postRequestWithFile(editLink, {
          "note_title": conTitle.text,
          "note_content": conContent.text,
          "id": widget.id.toString(),
        }, myImg!);
      }

      print("==========>>> $response");
      if (!mounted) {
        isloding = false;
        return;
      }
      if (response["status"] == "success") {
        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      } else {
        isloding = false;
        return ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("something went wrong")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    conTitle.text = widget.title;
    conContent.text = widget.content;
  }

  File? myImg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        onPressed: () async {
          await editNote();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Edit Note")),
      body: isloding
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  CustomTextForm(
                    controller: conTitle,
                    hint: titleHint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a title";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomTextForm(
                    controller: conContent,
                    hint: contentHint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter anything...";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  MaterialButton(
                    elevation: 5,
                    height: 50,
                    minWidth: 170,
                    color: Colors.green,
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            height: 160,
                            child: Column(
                              children: [
                                Text(
                                  "Select An Image",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      XFile? xfile = await ImagePicker()
                                          .pickImage(
                                            source: ImageSource.camera,
                                          );

                                      Navigator.of(context).pop();
                                      if (xfile != null) {
                                        myImg = File(xfile.path);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Text(
                                        "Camera 📷",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    XFile? xfile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    Navigator.of(context).pop();

                                    if (xfile != null) {
                                      myImg = File(xfile.path);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Text(
                                      "Gallery 🗂️",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Edit Image",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
