import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_tutorial/view/screens/auth/signup_screen.dart';

import 'constants.dart';
import 'controller/auth_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAles2m0YWFIjnhh8I0m_VhJtSzDXqSea4',
      appId: '1:371138917731:android:93579ade97268c83954f56',
      messagingSenderId: '371138917731',
      projectId: 'tiktok-clone-ae511',
      storageBucket: 'tiktok-clone-ae511.appspot.com',
    )
  ).then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: RegisterScreen(),
    );
  }
}

