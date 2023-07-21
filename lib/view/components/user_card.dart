import 'package:flutter/material.dart';
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
                  showAddOrUpdateUserSheet(context,user: user );
                  
                },
                child: const Text('UPDATE'),
              ),
              TextButton(
                onPressed: () async {
                  await UserViewModel.deleteUser(user.id);
                  Navigator.pop(context, 'Delete');
                },
                child: const Text('DELETE'),
              ),
            ],
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage:
                NetworkImage("user.image"), // assuming user has an image URL
          ),
          title: Text(user.username), // assuming user has a username property
        ),
      ),
    );
  }
}
