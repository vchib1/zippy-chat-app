import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/pages/auth_pages/signup_page.dart';
import 'package:zippchatapp/pages/widgets/custom_submit_button.dart';
import 'package:zippchatapp/pages/widgets/custom_textfield.dart';
import 'package:zippchatapp/providers/auth_provider.dart';
import '../../constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser(){
    context.read<AuthProvider>().signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SvgPicture.asset('assets/signUp.svg',height: MediaQuery.of(context).size.height*.5),

              //Email Field
              CustomTextField(
                  prefixIcon: Icons.mail,
                  labelText: "Email",
                  controller: _emailController,
                  obscureText: false,
              ),
              spaceWith10,

              //Password Field
              CustomTextField(
                prefixIcon: Icons.lock,
                labelText: "Password",
                controller: _passwordController,
                obscureText: true,
              ),
              spaceWith10,

              //Button
              CustomSubmitButton(
                  onPressed: () => loginUser(),
                  text: "Login",
              ),
              spaceWith10,

              GestureDetector(
                onTap: (){},
                child: const Text("Forgot Password?"),
              ),
              spaceWith10,

              GestureDetector(
                onTap: (){
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage(),));
                },
                child: const Text("Create New Account"),
              ),
              spaceWith10,

            ],
          ),
        ),
      ),
    );
  }
}
