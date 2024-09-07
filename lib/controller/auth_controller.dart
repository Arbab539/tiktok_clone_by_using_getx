import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../model/user_model.dart' as model;
import '../view/screens/auth/login_screen.dart';
import '../view/screens/home_screen.dart';


class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late final Rx<File?> _pickedImage = Rx<File?>(null); // Initialize with null
  final loading = false.obs;
  final Rx<Uint8List?> _image = Rx<Uint8List?>(null);
  Uint8List? get image => _image.value;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }


  //pickImage
  Future<void> selectImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Read the image file and convert it to Uint8List
      Uint8List? im = await pickedImage.readAsBytes();
      // Update _image with the selected image
      _image.value = im;
      _pickedImage.value = File(pickedImage.path); // Update _pickedImage
    }
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(
      String username,
      String email,
      String password,
      File? image
      ) async {
    try {

      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        loading.value = true;
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        Future.delayed(const Duration(seconds: 2), () {
          loading.value = false;
        });
        Get.snackbar('Registration', 'Registration Successfully');
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );

    }
  }

  void login(
      String email,
      String password
      ) async {
    try {
      if (
      email.isNotEmpty
          &&
          password.isNotEmpty
      ) {
        loading.value = true;
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password
        );

        Future.delayed(const Duration(seconds: 2),(){
          loading.value = false;
        });

        Get.snackbar('Login', 'Login Successfully');

      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error Login gin',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}

