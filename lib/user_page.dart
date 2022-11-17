import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:users_crud/user.dart';
import 'package:users_crud/user_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({this.user, Key? key}) : super(key: key);

  final User? user;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  late User? user;
  late String titleAction;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (user != null) {
      controllerName.text = user!.name;
      controllerAge.text = user!.age.toString();
      controllerDate.text = user!.birthday.toIso8601String();
    }
    titleAction = user != null ? 'Editar' : 'Criar';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('$titleAction Usuário'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: decoration('Name'),
                controller: controllerName,
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: decoration('Age'),
                keyboardType: TextInputType.number,
                controller: controllerAge,
              ),
              const SizedBox(height: 24),
              DateTimeField(
                  controller: controllerDate,
                  decoration: decoration('Birthday'),
                  format: DateFormat('yyyy-MM-dd'),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                  }),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  if (user == null) {
                    createUser();
                  } else {
                    updateUser(user!);
                  }
                  Navigator.pop(context);
                },
                child: Text(titleAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  void createUser() {
    final newUser = User(
      name: controllerName.text,
      age: int.parse(controllerAge.text),
      birthday: DateTime.parse(controllerDate.text),
    );
    UserService.createUser(newUser);
  }

  void updateUser(User user) {
    user.name = controllerName.text;
    user.age = int.parse(controllerAge.text);
    user.birthday = DateTime.parse(controllerDate.text);
    UserService.updateUser(user);
  }
}