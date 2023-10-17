import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sqf_pro/boxes/boxes.dart';
import 'package:sqf_pro/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive DataBase"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (BuildContext context, box, _) {
          final data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(data[index].title),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                delete(data[index]);
                              },
                              child: Icon(Icons.delete, color: Colors.red)),
                          SizedBox(width: 15),
                          InkWell(
                              onTap: () {
                                _updateDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString());
                              },
                              child: Icon(Icons.edit)),
                        ]),
                        Text(data[index].description)
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _updateDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Enter Title"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Description"),
                  )
                ],
              ),
            ),
            title: Text("Edit Notes"),
            actions: [
              TextButton(
                  onPressed: () {
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancle")),
              TextButton(
                  onPressed: () {
                    notesModel.title = titleController.text.toString();
                    notesModel.description =
                        descriptionController.text.toString();
                    notesModel.save();

                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Edit"))
            ],
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Enter Title"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Description"),
                  )
                ],
              ),
            ),
            title: Text("Add Notes"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancle")),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    data.save();

                    titleController.clear();
                    descriptionController.clear();

                    print(box);
                    Navigator.pop(context);
                  },
                  child: Text("Add"))
            ],
          );
        });
  }
}
