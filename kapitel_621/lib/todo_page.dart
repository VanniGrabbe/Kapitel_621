import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kapitel_621/toDo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List<ToDoItem> toDoList = [];
  TextEditingController textController = TextEditingController();

  void addToDo(){
    setState(() {
      String title = textController.text;
      if(title.isNotEmpty){
        toDoList.add(ToDoItem(title: title));
        textController.clear();
        saveToDoList();
      }
    });
  }
  void toggleToDoStatus(int index){
    setState(() {
      toDoList[index].isDone = !toDoList[index].isDone;
      saveToDoList();
    });
  }
  Future<void> saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'ToDoList';
    final toDoListJson = toDoList.map((todo) => todo.toJson()).toList();
    await prefs.setString(key, jsonEncode(toDoListJson));
  }
   @override
   void initState(){
    super.initState();
    loadToDoList();
   }
   Future<void> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'ToDoList';
    final toDoListJson = prefs.getString(key);
    if (
      toDoListJson != null){
        final List<dynamic> decodedList = jsonDecode(toDoListJson);
        setState(() {
          toDoList = decodedList.map((item) => ToDoItem.fromJson(item)).toList();
        });
      }
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo-List'),
        ),
        body: 
        Column(
          children: [
            Padding(padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Add a new To-Do'
              ),
            
            ),
            ),
            ElevatedButton(onPressed: addToDo, child: const Text('Add'),
            ),
              ],
            ),
            ),
            Expanded(child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index){
              return ListTile(
                leading: Checkbox(value: toDoList[index].isDone, onChanged: (value){
                  setState(() {
                    toDoList[index].isDone = value!;
                  });
                },
                ),
                title: Text(toDoList[index].title, style: TextStyle(
                  decoration: toDoList[index].isDone ? TextDecoration.lineThrough : null,
                ),),
              );
            }))
            
            
          
          ],
        ),
      ),
    );
  }
}