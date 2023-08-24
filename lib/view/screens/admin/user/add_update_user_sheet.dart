import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user.dart';
import '../../../../viewmodel/user_services.dart';
import '../../../components/app_colors.dart';

class AddOrUpdateUserSheet extends StatefulWidget {
  final User? user;

  AddOrUpdateUserSheet({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _AddOrUpdateUserSheetState createState() => _AddOrUpdateUserSheetState();
}

class _AddOrUpdateUserSheetState extends State<AddOrUpdateUserSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _selectedRole;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      emailController.text = widget.user!.email;
      usernameController.text = widget.user!.username;
      _selectedRole = widget.user!.role.toString().split('.').last;
    }
  }

  TextFormField buildTextField(
      TextEditingController controller, String label, Icon icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(32.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        filled: true,
        fillColor: AppColors.auxiliaryOffWhite,
        prefixIcon: icon,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Future<void> _handleUserAction() async {
    if (_formKey.currentState!.validate()) {
      if (widget.user != null) {
        await context.read<UserViewModel>().updateUser(
          id : widget.user!.id,
          email:emailController.text,
         username: usernameController.text,
          password :passwordController.text,
          role:_selectedRole!,
        );
      } else {
        await context.read<UserViewModel>().createUser(
          email :emailController.text,
          password :usernameController.text,
          username : passwordController.text,
          role :_selectedRole!,
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(emailController, 'Email',
                    const Icon(Icons.email, color: AppColors.auxiliaryGrey)),
                buildTextField(usernameController, 'Username',
                    const Icon(Icons.person, color: AppColors.auxiliaryGrey)),
                buildTextField(passwordController, 'Password',
                    const Icon(Icons.lock, color: AppColors.auxiliaryGrey)),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items:
                      <String>['Admin', 'Employee', 'Driver'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    _selectedRole = newValue;
                  },
                  decoration: InputDecoration(
                    labelText: 'Role',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.primaryOrange),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    filled: true,
                    fillColor: AppColors.auxiliaryOffWhite,
                    prefixIcon:
                        const Icon(Icons.work, color: AppColors.auxiliaryGrey),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _handleUserAction,
                  child: Text(widget.user != null ? 'Update' : 'Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
