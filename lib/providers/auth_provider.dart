import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zippchatapp/models/user_model.dart';
import 'package:zippchatapp/utils/show_snackbar.dart';
import '../pages/auth_pages/login_page.dart';
import '../pages/chat_pages/home_page.dart';
import '../utils/show_loading.dart';

class AuthProvider with ChangeNotifier{

  File? imageFile;
  bool fileLoaded = false;

  String? profilePic;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  //stream to check state change user logged or not
  Stream<User?> get user => auth.authStateChanges();

  //Stream to display current user's info
  Stream<DocumentSnapshot<Map<String, dynamic>>> userInfo(){
    return fireStore.collection('users').doc(auth.currentUser!.uid).snapshots();
  }

  //method to sign in
  Future<void> signInWithEmail({required String email,required String password,required BuildContext context})async{
    try{
      showLoadingDialog(context);
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {
        Navigator.pop(context),
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),))
      });
    }on FirebaseAuthException catch(e){
      showSnackBar(context, e.toString());
      Navigator.pop(context);
    }
  }

  //method to sign up and upload user details
  Future<void> signUpUser({required String name,required String email,required String password,required BuildContext context})async{
    try{
      //shows loading animation
      showLoadingDialog(context);

      //this create a user with email and password
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      if(credential.user != null){
        if(imageFile!=null){
          //this uploads the image to firebase storage and then url gets stored in the UserModel
          UploadTask uploadTask = storage.ref('profile pics').child(auth.currentUser!.uid).putFile(imageFile!);
          TaskSnapshot snapshot = await uploadTask;
          profilePic = await snapshot.ref.getDownloadURL();
        }
        UserModel userModel = UserModel(
          uid: credential.user!.uid,
          name: name,
          email: email,
          profilePic: profilePic ?? "null",
          about: "Hey there! I'm using ZippyChat",
          lastActive: "",
          isOnline: false,
          createdAt: Timestamp.now(),
          pushToken: "",
        );

        //this create a folder named with user's uid inside users folder that contains the UserModel
        fireStore.collection('users').doc(credential.user!.uid).set(userModel.toMap()).then((value) => {
          Navigator.pop(context),
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),))
        });
      }
    }on FirebaseAuthException catch(e){
      //pops the loading animation
      Navigator.pop(context);
      //shows a snack bar with the exception message
      showSnackBar(context, e.toString());
    }
  }

  //method to sign out
  void signOutUser(BuildContext context)async{
    try{
      await auth.signOut().then((value) => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),))
      });
    }on FirebaseAuthException catch(e){
      showSnackBar(context, e.toString());
    }
  }

  //method to update user's name
  Future editName(String name)async{
    await fireStore.collection('users').doc(auth.currentUser!.uid).update({
      "name": name
    });
  }

  //method to update about
  Future editAbout(String about)async{
    await fireStore.collection('users').doc(auth.currentUser!.uid).update({
      "about": about
    });
  }

  //method to update profile picture
  Future updateProfilePic()async{

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      cropImage(pickedFile);
    }

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 45,
    );

    if(croppedImage != null){
      imageFile = File(croppedImage.path);
    }else {
      return;
    }

    UploadTask uploadTask = storage.ref('profile pics').child(auth.currentUser!.uid).putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String profilePic = await snapshot.ref.getDownloadURL();

    await fireStore.collection('users').doc(auth.currentUser!.uid).update({
      "profilePic" : profilePic
    });
  }

  //method to select and crop image (sign up)
  void selectImage(ImageSource source)async{
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if(pickedFile!=null){
      cropImage(pickedFile);
    }
    notifyListeners();
  }
  void cropImage(XFile file)async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 45,
    );

    if(croppedImage != null){
      imageFile = File(croppedImage.path);
      fileLoaded = true;
    }else{
      return null;
    }
    notifyListeners();
  }
  void showImagePickOptions(BuildContext context){
    showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text("Select Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              ),
            ],
          ),
        );
      },
    );
  }

}