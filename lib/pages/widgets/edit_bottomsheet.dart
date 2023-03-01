import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/constants/constants.dart';
import 'package:zippchatapp/pages/widgets/custom_submit_button.dart';
import 'package:zippchatapp/pages/widgets/custom_textfield.dart';
import 'package:zippchatapp/providers/auth_provider.dart';

void editName(BuildContext context,TextEditingController controller){
  showBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                CustomTextField(
                    prefixIcon: Icons.person,
                    labelText: "Name",
                    obscureText: false,
                    controller: controller
                ),

                spaceWith10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomSubmitButton(
                        onPressed: ()=> Navigator.pop(context),
                        text: "Cancel"
                    ),
                    CustomSubmitButton(
                        onPressed: (){
                          context.read<AuthProvider>().editName(controller.text);
                          controller.clear();
                          Navigator.pop(context);
                        },
                        text: "Save"
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void editAbout(BuildContext context,TextEditingController controller){
  showBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                CustomTextField(
                    prefixIcon: Icons.person,
                    labelText: "About",
                    obscureText: false,
                    controller: controller
                ),

                spaceWith10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomSubmitButton(
                        onPressed: ()=> Navigator.pop(context),
                        text: "Cancel"
                    ),
                    CustomSubmitButton(
                        onPressed: (){
                          context.read<AuthProvider>().editAbout(controller.text);
                          controller.clear();
                          Navigator.pop(context);
                        },
                        text: "Save"
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
