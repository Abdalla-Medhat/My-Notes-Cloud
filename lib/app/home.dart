import 'package:api_php_mysql_training/app/notes/edit.dart';
import 'package:api_php_mysql_training/constant/api_links.dart';
import 'package:api_php_mysql_training/main.dart';
import 'package:api_php_mysql_training/models/notesmodel.dart';
import 'package:flutter/material.dart';
import 'package:api_php_mysql_training/app/component/crud.dart';
import 'package:api_php_mysql_training/app/component/cardnote.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Crud {
  Future getNotes() async {
    dynamic request = await postRequest(viewLink, {
      "id": pref!.getString("id"),
    });
    return request;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, "add");
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            color: Colors.red,
            onPressed: () {
              pref!.clear();
              Navigator.pushNamedAndRemoveUntil(
                context,
                "login",
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          FutureBuilder(
            future: getNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "There is an unexpected error, please try again later",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data["status"] == "no_internet") {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          "No internet connection",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MaterialButton(
                            height: 45,
                            minWidth: 140,
                            color: Colors.pink,
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text(
                              "Refresh",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // print("All data: ==============>${snapshot.data}");
                if (snapshot.data["status"] == "failed") {
                  return Center(
                    child: Text(
                      "There is an unexpected error, please try again later",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data["data"].length,
                  itemBuilder: (context, i) {
                    return Cardnote(
                      onPressed: () async {
                        var response = await postRequest(deleteLink, {
                          "id": snapshot.data["data"][i]["note_id"].toString(),
                          "imgName": snapshot.data["data"][i]["note_img"]
                              .toString(),
                        });
                        print("response: ========>$response");
                        if (response["status"] == "success") {
                          setState(() {});
                        } else if (response["status"] == "image not found") {
                          setState(() {});
                        } else {
                          print("something went wrong");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("something went wrong")),
                          );
                        }
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNote(
                              id: snapshot.data["data"][i]["note_id"],
                              title: snapshot.data["data"][i]["note_title"],
                              content: snapshot.data["data"][i]["note_content"],
                              img: snapshot.data["data"][i]["note_img"],
                            ),
                          ),
                        );
                      },
                      notesModel: NotesModel.fromJson(snapshot.data["data"][i]),
                    );
                  },
                );
              }

              return Center(
                child: Text(
                  "Something went wrong, you can help us by reporting this Error: ${snapshot.error}",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
