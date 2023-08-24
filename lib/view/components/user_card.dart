import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user.dart';
import '../../../../viewmodel/user_services.dart';
import '../screens/admin/user/add_update_user_sheet.dart';

class UserItem extends StatelessWidget {
  final User user;

  UserItem({
    required this.user,
  });

  void showAddOrUpdateUserSheet(BuildContext context, {User? user}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddOrUpdateUserSheet(
        user: user,
      ),
    );
  }

  void _showManageUserDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Manage User'),
        content: const Text('What do you want to do with this user?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Update');
              showAddOrUpdateUserSheet(context, user: user);
            },
            child: const Text('UPDATE'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<UserViewModel>().deleteUser(user.id);
              Navigator.pop(context, 'Delete');
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var status = 'Online';

    return GestureDetector(
      onLongPress: () => _showManageUserDialog(context),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage("https://picsum.photos/200/300"),
          radius: 30,
        ),
        title: Text(user.username,
            style: const TextStyle(color: Colors.black, fontSize: 16)),
        subtitle: Text(user.role.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: status == 'Online' ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
