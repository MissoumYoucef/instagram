import 'dart:typed_data';
import 'package:chatapp/responsive/mobile_screen_layout.dart';
import 'package:chatapp/responsive/responsive_layout.dart';
import 'package:chatapp/responsive/web_screen_layout.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../resources/auth_methods.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool isLoding = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void selectImage() async {
    Uint8List it = await pickImage(ImageSource.gallery);
    setState(() {
      _image = it;
    });
  }

  void logginUser() async {
    setState(() {
      isLoding = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res != 'succes') {
      if (context.mounted) {
        showSnackBar(context, res);
      }
    } else if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    setState(() {
      isLoding = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              // svg image
              //SvgPicture.asset('assets/insta.svg',colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),height: 64,)

              // PROFILE IMAGE

              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64, backgroundImage: MemoryImage(_image!))
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'data:image/jpeg;base64,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'),
                        ),
                  Positioned(
                    bottom: -10,
                    right: 10,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),

              // text field for userName

              TextFieldInput(
                  textEditingController: _userNameController,
                  hintText: 'Entre your Name',
                  textInputType: TextInputType.emailAddress),
              // text field for password
              const SizedBox(
                height: 30,
              ),

              // text field for email

              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Entre your email',
                  textInputType: TextInputType.emailAddress),

              const SizedBox(
                height: 30,
              ),

              // text field for password

              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Entre your password',
                  isPass: true,
                  textInputType: TextInputType.text),

              const SizedBox(
                height: 30,
              ),

              // text field for Bio

              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Entre your Bio',
                  textInputType: TextInputType.text),

              const SizedBox(
                height: 30,
              ),

              // bottom login

              InkWell(
                onTap: logginUser,
                child: isLoding
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ))
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            color: Colors.blue),
                        child: const Text('Sign Up')),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              // Transition to sign up

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Dont have an account?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Sign up'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
