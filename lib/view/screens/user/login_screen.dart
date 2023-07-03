
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';

import '../../components/app_colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}): super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      height: 150.0,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(50, 0, 50, 10),
      child: Image.asset("assets/Septeo-logo.svg.png"),
    );

    final email = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Email',
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
        prefixIcon: const Icon(
          Icons.email,
          color: AppColors.auxiliaryGrey ,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email address';
        }
        if (!EmailValidator.validate(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );

    final password = TextFormField(
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'password',
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
        prefixIcon: const Icon(
          Icons.lock,
          color: AppColors.auxiliaryGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );

    final loginButton = ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          
          String email = _emailController.text;
          String password = _passwordController.text;

          UserViewModel.login(email, password, context);
        }
      },
      style: ElevatedButton.styleFrom(
        primary: AppColors.primaryOrange,  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      child: const Text(
        'Log In',
        style: TextStyle(
          color: AppColors.auxiliaryOffWhite,  
          fontSize: 20.0,
        ),
      ),
    );

   return Scaffold(
      body: Center( 
        child: SingleChildScrollView(
          child: Padding(  
            padding: const EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: logo,
                  ),
                  const SizedBox(height: 20.0),  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: email,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: password,
                  ),
                  const SizedBox(height: 20.0), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: loginButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}