import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/pages/settings_profile/profile_edit.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fourthColor,
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: context.read<AuthProvider>().userInfo(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(snapshot.data!.data()!['profilePic']),
                  ),
                  title: Text(snapshot.data!.data()!['name']),
                  subtitle: Text(snapshot.data!.data()!['about']),
                  trailing: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage(),));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                );
              }else{
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
