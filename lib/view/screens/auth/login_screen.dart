import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_tutorial/view/screens/auth/signup_screen.dart';

import '../../../constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_input_field.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tiktok Clone',
              style: TextStyle(
                  fontSize: 35,
                  color: buttonColor,
                  fontWeight: FontWeight.w900
              ),
            ),

            const Text(
              'Login',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputField(
              controller: emailController,
              iconData: Icons.email,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),

            TextInputField(
              controller: passwordController,
              iconData: Icons.lock,
              labelText: 'Password',
              isObscure: true,
              suffixIconData: Icons.visibility,
              keyboardType: TextInputType.text,// Set the suffix icon to toggle visibility
            ),

            const SizedBox(
              height: 20,
            ),
            Obx(() => authController.loading.value
                ? const CircularProgressIndicator()
                : CustomButton(
              onTap: (){
                authController.login(emailController.text, passwordController.text);
              },
              text: 'Login',
            ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));

                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 20,
                        color: buttonColor
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
