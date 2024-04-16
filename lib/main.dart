import 'package:flutter/material.dart';

import 'package:todo_bloc/screens/todolist_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppBar(
      backgroundColor: const Color.fromARGB(255, 94, 91, 91),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: ListScreen(),
    );
  }
}
