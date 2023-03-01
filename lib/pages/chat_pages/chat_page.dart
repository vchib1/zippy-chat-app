import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippchatapp/models/user_model.dart';

import '../../constants/colors.dart';
import '../../models/message_model.dart';
import '../../providers/message_provider.dart';
import '../widgets/message_card.dart';

class ChatPage extends StatefulWidget {

  final UserModel userModel;

  const ChatPage({Key? key,required this.userModel}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List messages = [];

  final TextEditingController _messageController = TextEditingController();

  void sendMessage(){
    context.read<MessageProvider>().sendMessage(message: _messageController.text, userModel: widget.userModel);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: fourthColor,
          automaticallyImplyLeading: false,
        title: StreamBuilder(
          stream: context.read<MessageProvider>().getUserInfo(userModel: widget.userModel),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final data = snapshot.data!.docs;
              final list = data.map((e) => UserModel.fromMap(e.data())).toList();
              return Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0,right: 8.0),
                      child: Icon(Icons.arrow_back),
                    ),),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel.profilePic),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        children: [
                          TextSpan(text: widget.userModel.name,style: const TextStyle(fontSize: 20)),
                          const TextSpan(text: '\n'),
                          TextSpan(text: list.isNotEmpty && list[0].isOnline ? "online": "offline",style: const TextStyle(fontSize: 16)),
                        ]
                    ),
                  )
                ],
              );
            }else{
              return const SizedBox();
            }
          },
        )
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                stream: context.watch<MessageProvider>().fetchMessages(
                  userModel: widget.userModel,
                ),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: SizedBox(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data!.docs;
                      messages = data.map((e) => MessageModel.fromMap(e.data())).toList();
                      if(messages.isNotEmpty){
                        return ListView.builder(
                          itemCount: data.length,
                          //shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return MessageCard(
                                messageModel: messages[index],
                                currentUser: FirebaseAuth.instance.currentUser!.uid
                            );
                          },
                        );
                      }else{
                        return const Center(
                          child: Text("Hey There!"),
                        );
                      }
                  }
                },
              )
          ),

          Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: (){

                          },
                          icon: const Icon(Icons.emoji_emotions)
                      ),

                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                              hintText: "Write something...",
                              border: InputBorder.none
                          ),
                        ),
                      ),

                      IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.image)
                      ),
                      IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.camera_alt)
                      ),
                    ],
                  ),
                ),
              ),

              //send button
              IconButton(
                  onPressed: () => sendMessage(),
                  icon: const Icon(Icons.send,)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
