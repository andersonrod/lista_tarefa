import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Home (),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];
  @override
  void initState(){
    super.initState();
    _ReadData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }


  void _addToDo(){
   setState(() {
     Map<String, dynamic> newToDo = Map();
     newToDo["title"] = _toDoController.text;
     _toDoController.text = "";
     newToDo["OK"] = false;
     _toDoList.add(newToDo);
     _savedata();
   });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.cyan,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (context, index){
                return CheckboxListTile(
                  title: Text(_toDoList[index]["title"]),
                  value: _toDoList[index]["OK"],
                  secondary: CircleAvatar(
                    child: Icon(_toDoList[index]["OK"] ?
                    Icons.check:  Icons.error),
                  ),
                  onChanged: (c){
                    setState(() {
                      _toDoList[index]["OK"] = c;
                      _savedata();
                    });
                  },
                );
                }),
          ),
        ],
      ),
    );
  }

  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");

  }

  Future<File> _savedata() async{
    String data = json.encode(_toDoList);
    final File = await _getFile();
    return File.writeAsString(data);

  }

  Future<String> _ReadData() async{
    try {
      final File = await _getFile();

      return File.readAsString();
    } catch (e) {
      return null;

    }

  }

}




