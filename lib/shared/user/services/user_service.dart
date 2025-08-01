import 'package:boilerplate_template/shared/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/shared/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService implements IUserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toFirestore());
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModelFirestore.fromFirestore(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toFirestore());
  }

  @override
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}
