import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ets/database/todo_db.dart';
import 'package:ets/model/todo.dart';
import 'package:ets/widget/e_todo_widget.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  Future<List<Todo>>? futureTodos;
  final todoDB = TodoDB();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  // Fetch all datas from database
  // Called during initialization of state
  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final todos = snapshot.data!;

            return todos.isEmpty ? const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1,child: Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),),),
                      Text("harri potter")
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(flex: 1,child: Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg')),),
                      Text("Harry Potter 2")
                    ],
                  ),
                ],
              )
              // Text(
              //   'No Movies..',
              //   style: TextStyle(
              //     fontWeight: FontWeight.w700,
              //     fontSize: 28,
              //   ),
              // ),
            ) : ListView.separated(
              itemBuilder: (context, index) {
                final todo = todos[index];
                final subtitle = DateFormat('yyyy/MM/dd').format(
                    DateTime.parse(todo.updatedAt ?? todo.createdAt)
                );
                return ListTile(
                  title: Text(
                    todo.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(subtitle),
                  trailing: IconButton(
                    onPressed: () async {
                      await todoDB.delete(todo.id);
                      fetchTodos();
                    },
                    icon: const Icon(Icons.delete, color: Colors.red,),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateTodoWidget(
                        todo: todo,
                        onSubmit: (title) async {
                          await todoDB.update(id: todo.id, title: title, description: "halo");
                          fetchTodos();
                          if(!mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: todos.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(onSubmit: (title) async {
              await todoDB.create(title: title, description: "halo1");
              if (!mounted) return;
              fetchTodos();
              Navigator.of(context).pop();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
