class RegisterModel {
  final String name;
  final String login;
  final String email;
  final String password;
  final String? uid;

  RegisterModel({
    required this.name,
    required this.login,
    required this.email,
    required this.password,
    this.uid,
  });

  RegisterModel copyWith({
    String? name,
    String? login,
    String? email,
    String? password,
    String? uid,
  }) {
    return RegisterModel(
      name: name ?? this.name,
      login: login ?? this.login,
      email: email ?? this.email,
      password: password ?? this.password,
      uid: uid ?? uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'login': login,
      'email': email,
      'password': password,
      'uid': uid,
    };
  }
}
