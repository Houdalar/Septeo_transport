class User {
  final String email;
  final String password;
  final String username;
  Role role;
 

  User(
      {required this.email,
      required this.password,
      required this.username,
      required this.role
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      username: json['username'],
      role: Role.values.firstWhere((e) => e.toString() == 'Role.' + json['Role'],),
     
    );
  }
}

enum Role { Admin, Employee, Driver }