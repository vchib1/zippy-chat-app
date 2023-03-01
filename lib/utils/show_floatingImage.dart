import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

void showFloatingImage(BuildContext context,String profilePic){
  showDialog(useSafeArea: true,context: context, builder:  (context) {
    return Center(
      child: Hero(
        tag: profilePic,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .35,
          width: MediaQuery.of(context).size.height * .35,
          child: PhotoView(
            imageProvider: NetworkImage(profilePic),
          ),
        ),
      ),
    );
  },
  );
}