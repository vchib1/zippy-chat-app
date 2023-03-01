import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/pages/auth_pages/login_page.dart';
import 'package:zippchatapp/pages/widgets/custom_submit_button.dart';
import 'package:zippchatapp/pages/widgets/custom_textfield.dart';
import 'package:zippchatapp/providers/auth_provider.dart';
import 'package:zippchatapp/utils/show_snackbar.dart';
import '../../constants/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>().fileLoaded = false;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cPasswordController.dispose();
    _passwordController.dispose();
  }

  void signUpUser(){
    if(_nameController.text.isEmpty && _passwordController.text.isEmpty && _cPasswordController.text.isEmpty && _emailController.text.isEmpty){
      showSnackBar(context, "Please fill all the Fields");
    }else if(_passwordController.text != _cPasswordController.text){
      showSnackBar(context, "Password does not match!!");
    }else{
      context.read<AuthProvider>().signUpUser(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          context: context
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    var providerWatch = context.watch<AuthProvider>();
    var providerRead = context.watch<AuthProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              spaceWith10,
              spaceWith10,
              spaceWith10,
              spaceWith10,
              spaceWith10,

              //Profile Pic
              GestureDetector(
                onTap: () => providerRead.showImagePickOptions(context),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: providerWatch.fileLoaded ? FileImage(providerRead.imageFile!) : null,
                      child: providerWatch.fileLoaded ? null : const Icon(Icons.person,size: 75,),
                    ),
                    const Positioned(
                        right: 0,
                        top: 100,
                        child: Icon(
                          Icons.camera_alt,
                          size: 35,),
                    ),
                  ],
                ),
              ),
              spaceWith10,
              spaceWith10,

              //Email Field
              CustomTextField(
                prefixIcon: Icons.person,
                labelText: "Name",
                controller: _nameController,
                obscureText: false,
              ),
              spaceWith10,

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

              //Confirm Pass Field
              CustomTextField(
                prefixIcon: Icons.lock,
                labelText: "Confirm Password",
                controller: _cPasswordController,
                obscureText: true,
              ),
              spaceWith10,

              //Button
              CustomSubmitButton(
                onPressed: () => signUpUser(),
                text: "SignUp",
              ),
              spaceWith10,

              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                },
                child: const Text("Already Have an account? Login here"),
              ),
              spaceWith10,

            ],
          ),
        ),
      ),
    );
  }
}
