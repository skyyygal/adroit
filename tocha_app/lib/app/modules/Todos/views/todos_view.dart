import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tocha_app/app/modules/Dashboard/controllers/dashboard_controller.dart';

import '../controllers/todos_controller.dart';

class TodosView extends GetView<TodosController> {
  final TodosController _todosController = Get.put(TodosController());
  TodosView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Todos',
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.offNamed('/chat');
                    },
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/chat.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Exit'),
                          content: const Text('Are you sure you want to exit?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                Get.find<DashboardController>().logOut();
                              },
                              child: const Text('Exit'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Obx(
                () => ListView.builder(
                  itemCount: _todosController.todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todosController.todos[index];
                    return GestureDetector(
                      onTap: () => _viewTodosDetails(todo),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) =>
                                    _todosController.deleteTodos(todo.id),
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              )
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(
                                todo.title,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              subtitle: Text(todo.description),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String title = '';
              String description = '';
              return AlertDialog(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Add Todo',
                  style: TextStyle(
                    color: Color.fromARGB(255, 102, 91, 91),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      //  controller: controller.textController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Add new todo item',
                        hintStyle: TextStyle(color: Colors.white60),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => description = value,
                      decoration: const InputDecoration(
                        hintText: 'Add Description',
                        hintStyle: TextStyle(color: Colors.white60),
                      ),
                    )
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          _todosController.createTodos(
                            title,
                            description,
                          );
                          Get.back();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

void _viewTodosDetails(Todos todo) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.yellow[100],
      title: Text(todo.title),
      content: Text(todo.description),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
