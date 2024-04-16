import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? todo;
  AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo["description"];
      titleController.text = title;
      descriptionController.text = description;
    }

    super.initState();

    if (widget.todo != null) {
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 50, 50),
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? upadateData : submitData,
            child: Text(isEdit ? "Update" : "Submit"),
          ),
        ],
      ),
    );
  }

  Future<void> upadateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("you can not call the update without todo data");
      return;
    }
    final id = todo['_id'];
    
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
      if (response.statusCode == 200) {
     
      showSuccessMessanger("Update success");
    } else {
      showErrorMessage("updation failed");
    }
  
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = '';
      showSuccessMessanger("Creation Success");
    } else {
      showErrorMessage(response.body);
    }
  }

  void showSuccessMessanger(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(
    String message,
  ) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
