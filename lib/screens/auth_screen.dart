import 'package:demoapp/animations/fade_transition.dart';
import 'package:demoapp/models/user.dart';
import 'package:demoapp/screens/home_screen.dart';
import 'package:demoapp/widgets/app_button.dart';
import 'package:demoapp/widgets/app_icon.dart';
import 'package:demoapp/widgets/background.dart';
import 'package:demoapp/widgets/error_dialog.dart';
import 'package:demoapp/widgets/loading_spinner.dart';
import 'package:demoapp/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/select_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String gender = '';
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void getValue(String parameter, String val) {
    setState(() {
      if (parameter == 'Gender') {
        gender = val;
      }
    });
  }

  bool validate() {
    if (firstnameController.text == '' ||
        lastnameController.text == '' ||
        passwordController.text == '' ||
        emailController.text == '' ||
        gender == '') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> saveDetails() async {
    toggleLoading();

    if (validate()) {
      final userStats = Provider.of<UserStats>(context, listen: false);

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await userStats.uploadUserStats(
          gender,
          emailController.text,
          firstnameController.text,
          lastnameController.text,
        );
      } catch (error) {
        toggleLoading();

        showDialog(
            context: context,
            builder: (ctx) =>
                ErrorDialog(title: 'Error', text: error.toString()));

        return;
      }
    }

    toggleLoading();

    Navigator.of(context).push(FadeTransiton(HomeScreen(), 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            const MyBackground(),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _isLoading
                  ? const LoadingSpinner()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: SizedBox()),
                          const AppIcon(size: 140),
                          const Text(
                            'Welcome to our app.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Please fill the required details below',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 30),
                          MyTextField(
                            controller: firstnameController,
                            hintText: 'First name',
                            onChanged: getValue,
                            textInputType: TextInputType.text,
                          ),
                          MyTextField(
                            controller: lastnameController,
                            hintText: 'Last name',
                            onChanged: getValue,
                            textInputType: TextInputType.text,
                          ),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email address',
                            onChanged: getValue,
                            textInputType: TextInputType.emailAddress,
                          ),
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            onChanged: getValue,
                            textInputType: TextInputType.text,
                            isPassword: true,
                          ),
                          SelectField(
                            text: 'Gender',
                            initialValue: gender,
                            getGender: getValue,
                          ),
                          const Expanded(child: SizedBox()),
                          AppButton(
                            onPressed: saveDetails,
                            text: 'Submit',
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
