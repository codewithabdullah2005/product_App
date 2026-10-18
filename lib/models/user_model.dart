
class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // Model ko Map mein convert karna
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  // Firestore Map se UserModel banana
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
