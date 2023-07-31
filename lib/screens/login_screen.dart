import 'package:chatapp/screens/signup_screen.dart';
import 'package:chatapp/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoding = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logginUser() async {
    setState(() {
      isLoding = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
     if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
            ),
            (route) => false);

        setState(() {
          isLoding = false;
        });
      }
    } else {
      setState(() {
        isLoding = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignUpScreen(),
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

              // text field for email

              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Entre your email',
                  textInputType: TextInputType.emailAddress),
              // text field for password
              const SizedBox(
                height: 30,
              ),

              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Entre your password',
                  isPass: true,
                  textInputType: TextInputType.text),
              // bottom login
              const SizedBox(
                height: 30,
              ),

              //Login

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
                        child: const Text('Login')),
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
