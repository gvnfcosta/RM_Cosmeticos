class UserModel {
  String id;
  String name;
  String email;
  String password;
  double discount;
  int level;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.discount,
    required this.level,
  });
}

class User {
  String? email;
  String? password;

  User();

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
