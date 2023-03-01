import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../constants/colors.dart';

class FullScreenPage extends StatelessWidget {

  final String profilePic;

  const FullScreenPage({Key? key,required this.profilePic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fourthColor,
      ),
      body: Center(
        child: Hero(
          tag: profilePic,
          child: SizedBox(
            child: PhotoView(
              imageProvider: NetworkImage(profilePic),
            ),
          ),
        ),
      ),
    );
  }
}
