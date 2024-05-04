import 'package:auth_project/pages/home_screen.dart';
import 'package:auth_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

const users =  {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUserSignUp(SignupData data) {
    debugPrint('SignUp Succes!\n Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(data.name, data.password);
      } catch (error) {
        return error.toString();
      }
      return null;
    });
  }

  Future<String?> _authUserLogin(LoginData data) {
    debugPrint('Login Succes!\n Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(data.name, data.password);
      } catch (error) {
        return error.toString();
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/tablet-login-cuate.png'),
      onLogin: _authUserLogin,
      onSignup: _authUserSignUp,
      onSubmitAnimationCompleted: () {
        Provider.of<AuthProvider>(context, listen: false).tempData();
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}