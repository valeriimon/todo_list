import 'dart:math';

import 'todo_list.dart';



class TodoController extends ResourceController {
  List tasks = [
    { 'id': 1, 'title': 'title 1', 'description': 'Description 1', 'done': false}
  ];

  int generateTaskId() {
    int random;
    while(true) {
      random = Random().nextInt(100);
      if(tasks.indexWhere((task) => task['id'] == random) < 0) {
        break;
      }
    }
    return random;
  }

  @Operation.get()
  Future<Response> getTasks() async {
    return Response.ok(tasks);
  }

  @Operation.get('id')
  Future<Response> getTaskById(@Bind.path('id') int taskId) async {
    final dynamic task = tasks.firstWhere((task) => task['id'] == taskId);
    return Response.ok(task);
  }

  @Operation.post()
  Future<Response> createTask() async {
    final dynamic newTask = await request.body.decode();
    newTask['id'] = generateTaskId();
    tasks.add(newTask);
    print(tasks);
    return Response.ok(true);
  }
  
  @Operation.put()
  Future<Response> updateTask() async {
    final dynamic updatedTask = await request.body.decode();
    
    final int index = tasks.indexWhere((task) => task['id'] == updatedTask['id']);
    if(index < 0) {
      return Response.badRequest();
    }

    tasks[index] = updatedTask;
    return Response.ok(true);
  }
  
  @Operation.delete('id')
  Future<Response> deleteTask(@Bind.path('id') int taskId) async {
    tasks.removeWhere((task) => task['id'] == taskId);
    print(tasks);
    return Response.ok(true);
  }
}