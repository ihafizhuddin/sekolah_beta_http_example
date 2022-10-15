import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Demo',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HttpExamplePage(),
    );
  }
}

class HttpExamplePage extends StatelessWidget {
  const HttpExamplePage({Key? key}) : super(key: key);

  Future<List<TodoItem>> getTodos() async {
    Response res =
        await get(Uri.http('jsonplaceholder.typicode.com', '/todos'));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<TodoItem> todos = body.map((item) {
        return TodoItem(
          title: item['title'],
          completed: item['completed'] as bool,
        );
      }).toList();
      return todos;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Example'),
      ),
      body: FutureBuilder(
        future: getTodos(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoItem>> snapshot) {
          if (snapshot.hasData) {
            List<TodoItem> todos = snapshot.data!;
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: todos[index].completed
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.check_box_outline_blank),
                      title: Text(todos[index].title),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class TodoItem {
  const TodoItem({
    required this.title,
    required this.completed,
  });
  final String title;
  final bool completed;
}
