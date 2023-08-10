class User {
  String id;
  String email;
  String password;
  String username;
  Role role;
  String registrationToken;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    required this.role,
    required  this.registrationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Role role;

    switch (json['role']) {
      case 'Admin':
        role = Role.Admin;
        break;
      case 'Employee':
        role = Role.Employee;
        break;
      case 'Driver':
        role = Role.Driver;
        break;
      default:
        role = Role.Employee;
    }

    return User(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      role: role,
      registrationToken: json['registrationToken'],
      
    );
  }
}

enum Role { Admin, Employee, Driver }

class LoginResponse {
  String? token;
  
}