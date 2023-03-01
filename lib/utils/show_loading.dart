import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context){
  showDialog(useSafeArea: true,context: context, builder:  (context) {
    return const Center(
      child: CircularProgressIndicator(),
      );
    },
  );
}