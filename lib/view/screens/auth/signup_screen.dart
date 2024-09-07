
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_tutorial/view/screens/auth/login_screen.dart';

import '../../../constants.dart';
import '../../../controller/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_input_field.dart';


class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

   RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 60),
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
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  Obx(() {
                    if (authController.image != null) {
                      return CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(authController.image!),
                        backgroundColor: Colors.red,
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                        backgroundColor: Colors.red,
                      );
                    }
                  }
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        authController.selectImage();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                controller: usernameController,
                iconData: Icons.person,
                labelText: 'Username',
                keyboardType: TextInputType.text,
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
                keyboardType: TextInputType.text,
                suffixIconData: Icons.visibility, // Set the suffix icon to toggle visibility
              ),
              const SizedBox(
                height: 25,
              ),
              Obx(() => authController.loading.value
                  ? const CircularProgressIndicator()
                  : CustomButton(
                onTap: () {
                  authController.registerUser(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                    authController.profilePhoto,
                  );
                },
                text: 'Register',
              )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20,
                          color: buttonColor
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



