import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_crud/user.dart';

class UserService {
  static Future<void> createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }

  static Future<void> updateUser(User user) async {
    final docUser = FirebaseFirestore.instance
        .collection('users').doc(user.id);
    final json = user.toJson();
    await docUser.update(json);
  }

  static Stream<List<User>> readUsers() {
    return FirebaseFirestore.instance.collection('users')
        .snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) =>
                User.fromJson(doc.data())).toList());
  }

  static Future<void> deleteUser(User user) async {
    final docUser = FirebaseFirestore.instance
        .collection('users').doc(user.id);
    await docUser.delete();
  }
}
