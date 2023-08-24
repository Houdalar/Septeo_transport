import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/view/components/app_colors.dart';
import '../../../../model/user.dart';
import '../../../../viewmodel/user_services.dart';
import '../../../components/user_card.dart';
import 'add_update_user_sheet.dart';

class UserManagement extends StatefulWidget {

  const UserManagement({
    Key? key,
  }) : super(key: key);

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  void _showAddOrUpdateUserSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddOrUpdateUserSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUserList(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('User Management'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkBlue),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildUserList() {
    return FutureBuilder<List<User>>(
      future: context.read<UserViewModel>().getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              User user = snapshot.data![index];
              return UserItem(user: user);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showAddOrUpdateUserSheet(context),
      backgroundColor: AppColors.secondaryDarkOrange,
      child: const Icon(Icons.add),
    );
  }
}
