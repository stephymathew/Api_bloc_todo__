import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:todo_bloc/screens/add_page.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    FetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo List",
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 51, 48, 48),
      ),
      body: RefreshIndicator(
        onRefresh: FetchTodo,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index] as Map;
            final id = item['_id'] as String;
            return ListTile(
              leading: CircleAvatar(child: Text("${index + 1}")),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == "edit") {
                    navigateToEditPage(context, item);
                  } else if (value == "delete") {
                    deleteById(id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text("edit"),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                      value: 'delete',
                    )
                  ];
                },
              ),
            );
          },
        ),
      ),
      // body: Visibility(
      //   visible: isLoading,
      //   replacement: Center(child: CircularProgressIndicator(),),
      //   child: RefreshIndicator(
      //     onRefresh: FetchTodo,
      //     child: Column(
      //       children: [
      //         ListView.builder(
      //             itemCount: items.length,
      //             itemBuilder: (context, index) {
      //               final item = items[index] as Map;
      //               return ListTile(
      //                 leading: CircleAvatar(
      //                   child: Text("${index + 1}"),
      //                 ),
      //                 title: Text(item["title"]),
      //                 subtitle: Text(item['description']),
      //               );
      //             } // title: Text("Sample Text"),
      //             // ),
      //       ],
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddTodo(context);
        },
        label: const Text("add"),
      ),
    );
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage("Deletion failed");
    }
  }

  Future<void> FetchTodo() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    // setState(() {
    //   isLoading = false;
    // });
    // print(response.statusCode);
    // print(response.body);
  }

  Future<void> navigateToAddTodo(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodo()),
    );
    setState(() {
      isLoading = true;
    });
    FetchTodo();
  }

  Future<void> navigateToEditPage(BuildContext context, Map item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodo(
          todo: item,
        ),
      ),
    );
    setState(() {
      isLoading = true;
    });
    FetchTodo();
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
