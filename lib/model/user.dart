class User {
  String id;
  String email;
  String password;
  String username;
  Role role;
  List<String> weeklyPlanning;

  User({required this.id, required this.email, required this.password, required this.username, required this.role, required this.weeklyPlanning});

  factory User.fromJson(Map<String, dynamic> json) {
    var list = json['weeklyPlanning'] as List;
    List<String> weeklyPlanningList = list.map((i) => i.toString()).toList();
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
      weeklyPlanning: weeklyPlanningList,
    );
  }
}
enum Role { Admin, Employee, Driver }