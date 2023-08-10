import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/constatns.dart';
import '../../../../model/user.dart';
import '../../../../viewmodel/user_services.dart';
import '../screens/admin/user/add_update_user_sheet.dart';

class UserItem extends StatelessWidget {
  final User user;

  UserItem({required this.user});

  void showAddOrUpdateUserSheet(BuildContext context, {User? user}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddOrUpdateUserSheet(user: user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var status = 'Online' ;
    return GestureDetector(
      onLongPress: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Manage User'),
            content: const Text('What do you want to do with this user?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Update');
                  showAddOrUpdateUserSheet(context, user: user);
                },
                child: const Text('UPDATE'),
              ),
              TextButton(
                onPressed: () async {
                  final userViewModel = Provider.of<UserViewModel>(context, listen: false);
                  await userViewModel.deleteUser(user.id);
                  Navigator.pop(context, 'Delete');
                },
                child: const Text('DELETE'),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage("user.imageUrl"), // assuming user has an image URL
          radius: 30,
        ),
        title: Text(user.username, style: const TextStyle(color: Colors.black, fontSize: 16)),
        subtitle: Text(user.role.toString(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
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