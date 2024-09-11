class UserModel {
  String id;
  String email;
  String role;

  UserModel({required this.id, required this.email, required this.role});

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      email: data['email'],
      role: data['role'],
    );
  }
}
