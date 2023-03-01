import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/constants/colors.dart';
import 'package:zippchatapp/constants/constants.dart';
import 'package:zippchatapp/models/user_model.dart';
import 'package:zippchatapp/pages/chat_pages/chat_page.dart';
import 'package:zippchatapp/pages/settings_profile/settings.dart';
import 'package:zippchatapp/providers/auth_provider.dart';
import 'package:zippchatapp/utils/show_floatingImage.dart';
import '../../providers/message_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MessageProvider>().changeOnlineStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message){
      if(message.toString().contains("pause")) context.read<MessageProvider>().changeOnlineStatus(false);
      if(message.toString().contains("resume")) context.read<MessageProvider>().changeOnlineStatus(true);
        return Future.value(message);
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fourthColor,
        title: const Text("ZippyChat"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: IconButton(
              onPressed: (){
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => const SearchPage(),
                // ));
              },
              icon: const Icon(Icons.search),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value){
              if(value == 0){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ));
              }
              if(value == 1){
                context.read<AuthProvider>().signOutUser(context);
              }
            },
            itemBuilder: (context)=>[
              const PopupMenuItem(
                value: 0,
                child: Text("Settings"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Log Out"),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where("uid",isNotEqualTo: context.read<AuthProvider>().auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.done:
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Theme.of(context).disabledColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        leading: GestureDetector(
                          onTap: () => showFloatingImage(context, snapshot.data!.docs[index]['profilePic']),
                          child: Hero(
                            tag: snapshot.data!.docs[index]['profilePic'],
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(snapshot.data!.docs[index]['profilePic']),
                            ),
                          ),
                        ),
                        title: Text(snapshot.data!.docs[index]['name'],style: nameStyle,),
                        subtitle: Text(snapshot.data!.docs[index]['about'],style: aboutStyle,),
                        trailing: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                              userModel: UserModel(
                                  profilePic: snapshot.data!.docs[index]['profilePic'],
                                  about: snapshot.data!.docs[index]['about'],
                                  name: snapshot.data!.docs[index]['name'],
                                  createdAt: snapshot.data!.docs[index]['createdAt'],
                                  uid: snapshot.data!.docs[index]['uid'],
                                  lastActive: snapshot.data!.docs[index]['lastActive'],
                                  email: snapshot.data!.docs[index]['email'],
                                  pushToken: snapshot.data!.docs[index]['pushToken'],
                                  isOnline: snapshot.data!.docs[index]['isOnline']
                              ),
                            ),
                            ));
                          },
                          child: const Icon(Icons.messenger_outline_sharp)
                        ),
                      ),
                    );
                  },
                );
              }else{
                return const SizedBox();
              }
          }
        },
      ),
    );
  }
}
