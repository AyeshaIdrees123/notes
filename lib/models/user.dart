class UserModel {
  String id;
  String name;
  String email;
  String password;
  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: 'userId',
      name: 'name',
      email: 'email',
      password: 'password',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
