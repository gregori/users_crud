import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:users_crud/user.dart';
import 'package:users_crud/user_page.dart';
import 'package:users_crud/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: StreamBuilder(
        stream: UserService.readUsers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) =>
                  buildUser(context, users[index]),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UserPage(),
            ),
          );
        },
      ),
    );
  }
  Widget buildUser(BuildContext context, User user) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${user.age}'),
      ),
      title: Text(user.name),
      subtitle: Text(user.birthday.toIso8601String()),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserPage(user: user),
          ),
        );
      },
      onLongPress: () {
        UserService.deleteUser(user);
      },
    );
  }
}
