import 'dart:io';
import 'package:api_php_mysql_training/app/component/costomTextform.dart';
import 'package:api_php_mysql_training/app/component/crud.dart';
import 'package:api_php_mysql_training/constant/api_links.dart';
import 'package:api_php_mysql_training/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with Crud {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController conTitle = TextEditingController();
  TextEditingController conContent = TextEditingController();

  File? myImg;
  bool isloding = false;
  String titleHint = "Add a title";
  String contentHint = "Type the content";
  Future addNote() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloding = true;
      });
      var response = await postRequest(addLink, {
        "note_title": conTitle.text,
        "note_content": conContent.text,
        "user_note": pref!.getString("id"),
      });
      if (!mounted) {
        setState(() {
          isloding = false;
        });
        return;
      }
      if (response == null) {
        setState(() {
          isloding = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No response from server")));
        return;
      }

      if (response["status"] == "success") {
        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      } else {
        print("Error=============================>$response");
        setState(() {
          isloding = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "something went wrong",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        );
        return;
      }
    }
  }

  Future addNoteWithImage() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloding = true;
      });
      print("Image path: ${myImg!.path}");

      var response = await postRequestWithFile(addLink, {
        "note_title": conTitle.text,
        "note_content": conContent.text,
        "user_note": pref!.getString("id"),
      }, myImg!);
      if (!mounted) {
        isloding = false;
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 10),
              Text("Uploading file..."),
            ],
          ),
          duration: Duration(hours: 2),
        ),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      print("====>>response: $response");
      if (response == null) {
        // hide current snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No response from server")));
        return;
      }
      if (response["status"] == "failed") {
        print("====================");
        print(response["error"]);
        print("====================");
        var error = response["error"];
        if (error is String && error.contains("Image size exceeds 2 MB")) {
          setState(() {
            isloding = false;
            // hide current snackbar
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Image size exceeds 2 MB",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
          return;
        } else if (error is String && error.contains("Invalid image type")) {
          setState(() {
            isloding = false;
          });
          // hide current snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Invalid image type",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
          return;
        } else {
          setState(() {
            isloding = false;
          });
          // hide current snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "something went wrong",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
          return;
        }
      }
      if (response["status"] == "success") {
        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      } else {
        isloding = false;
        // hide current snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("something went wrong")));
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            onPressed: () async {
              if (myImg != null) {
                await addNoteWithImage();
              } else {
                await addNote();
              }
            },
            child: const Icon(Icons.add),
          ),
          SizedBox(width: 35),
          FloatingActionButton(
            heroTag: "img",
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
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
                              XFile? xfile = await ImagePicker().pickImage(
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
                            XFile? xfile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
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
            child: const Icon(Icons.image),
          ),
        ],
      ),
      appBar: AppBar(title: const Text("Add Note")),
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
                ],
              ),
            ),
    );
  }
}
