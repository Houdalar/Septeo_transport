import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import '../../../../model/user.dart';
import '../../../../viewmodel/user_services.dart';
import '../../../components/user_card.dart';
import 'add_update_user_sheet.dart';


class UserManagement extends StatefulWidget {
  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
   void showAddOrUpdateUserSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddOrUpdateUserSheet();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management', style: TextStyle(color: Colors.white))
      ),
      body: FutureBuilder<List<User>>(
        future: UserViewModel.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                User user = snapshot.data![index];
                return UserItem(user: user);  // Updated line
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         showAddOrUpdateUserSheet(context );
        },
        backgroundColor: AppColors.secondaryDarkOrange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
