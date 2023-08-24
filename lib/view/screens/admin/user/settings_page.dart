import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../session_manager.dart';
import '../../../components/app_colors.dart';
import 'login_screen.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({
    Key? key,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await context.read<SessionManager>().clearSession();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSettingCard(
                title: 'Logout',
                icon: const Icon(Icons.logout, color: AppColors.primaryOrange),
                onTap: () => _logout(context),
              ),
              _buildSettingCard(
                title: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (bool value) {},
                  activeColor: AppColors.primaryOrange,
                ),
              ),
              _buildSettingCard(
                title: 'Privacy',
                icon: const Icon(Icons.privacy_tip, color: AppColors.primaryOrange),
              ),
              _buildSettingCard(
                title: 'About Us',
                icon: const Icon(Icons.info_outline, color: AppColors.primaryOrange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingCard({
    required String title,
    Widget? icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ?? icon,
        onTap: onTap,
      ),
    );
  }
}
