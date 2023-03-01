import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/constants/constants.dart';
import 'package:zippchatapp/pages/settings_profile/fullscreen_page.dart';
import 'package:zippchatapp/pages/widgets/edit_bottomsheet.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    aboutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fourthColor,
        title: const Text("Profile"),
      ),
      body:  StreamBuilder(
        stream: context.read<AuthProvider>().userInfo(),
        builder: (context, snapshot) {
          nameController.text = snapshot.data!.data()!['name'];
          aboutController.text = snapshot.data!.data()!['about'];

          var profilePic = snapshot.data!.data()!['profilePic'];

          if(snapshot.hasData && snapshot.connectionState == ConnectionState.active){
            return Column(
              children: [
                spaceWith10,
                spaceWith10,
                SizedBox(
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        if(profilePic != "null"){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenPage(profilePic: snapshot.data!.data()!['profilePic']),));
                        }
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: snapshot.data!.data()!['profilePic'],
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage: profilePic == "null" ? null : NetworkImage(snapshot.data!.data()!['profilePic']),
                              child: profilePic == "null" ? const Icon(Icons.person,size: 75,) : null,
                            ),
                          ),
                          Positioned(
                              right: -10,
                              top: 100,
                              child: IconButton(
                                onPressed: () => context.read<AuthProvider>().updateProfilePic(),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 35,),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                spaceWith10,
                spaceWith10,
                ListTile(
                  leading: const Icon(Icons.person,size: 35,),
                  title: const Text("Name"),
                  subtitle: Text(snapshot.data!.data()!['name']),
                  trailing: IconButton(
                    onPressed: (){
                      editName(context, nameController);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info,size: 30,),
                  title: const Text("About"),
                  subtitle: Text(snapshot.data!.data()!['about']),
                  trailing: IconButton(
                    onPressed: (){
                      editAbout(context, aboutController);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                )
              ],
            );
          }else{
            return const SizedBox();
          }
        },
      ),
    );
  }
}
