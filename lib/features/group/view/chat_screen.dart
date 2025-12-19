import 'package:allergy_helper_project/features/auth/data/user_model.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/group/logic/group_provider.dart';
import 'package:allergy_helper_project/features/group/logic/message_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatefulWidget {//StatefulWidget that accepts the following parameters:
//groupId,groupName,adminId
  final String groupId;
  final String groupName;
  final String adminId;

  const ChatScreen({// constructor for the ChatScreen
    super.key,// passed to the superclass"StatefulWidget",  used to preserve the state of a widget
    required this.groupId,//passed when creating an instance of the ChatScreen
    required this.groupName,
    required this.adminId,
  });

  @override
  ChatScreenState createState() => ChatScreenState();// responsible for creating the state of the widget
}

class ChatScreenState extends State<ChatScreen> {
  //**handling the reporting of a message in the chat. **
  void _reportMessage(String messageId, String text) async {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

    showDialog(//displays a dialog window
      context: context,
      builder: (context) => AlertDialog(//dialog widget in Flutter that is typically used for alerts, warnings, or confirmations.
        title: Text("Report Message"),//**titlr when user make report */
        content:
            Text("Are you sure you want to report this message?\n\n\"$text\""),//**the text display in the box */
        actions: [//The dialog contains two buttons:
          TextButton(//cancle operation
            onPressed: () => Navigator.pop(context),//go back to the basic bage
            child: Text("Cancel"),
          ),
          TextButton(//report message
            onPressed: () async {//when pressed give me thoses info 
              final reportData = {
                'messageId': messageId,
                'reportedBy': authProvider.user!.uid,
                'timestamp': FieldValue.serverTimestamp(),
                'messageText': text,
              };

              // Save the report to Firestore (or any backend service)
              await FirebaseFirestore.instance
                  .collection('reported_messages')
                  .add(reportData);//add it to reported messages

              if (context.mounted) {//ensure that the context is still valid (i.e., the widget hasn't been disposed)
                Navigator.pop(context);//back to basic page

                ScaffoldMessenger.of(context).showSnackBar(//ScaffoldMessenger is used to show the SnackBar.
                  SnackBar(
                    content: Text("Message reported successfully."),//bar that tell that message is reported
                  ),
                );
              }
            },
            child: Text("Report"),//**name of button for reporting */
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final authProvider = Provider.of<AppAuthProvider>(context);
    //**IconButton : that, when pressed, opens a PopupMenu. This menu provides additional actions, 
    //one of which allows the user to view the group members */
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),//the current group will be the title
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),// this icon : above 
            onPressed: () async {//when pressing :
            //**//display a popup menu with multiple items */
              showMenu(
                context: context,
                shape: RoundedRectangleBorder(//shape of menu
                  borderRadius: BorderRadius.circular(10),
                ),
                position: const RelativeRect.fromLTRB(1, 80, 0, 0),//, it's positioned near the icon button
                items: [//list of PopupMenuItems to display in the menu
                  PopupMenuItem(//Each PopupMenuItem can contain various widgets, like a ListTile.
                    child: const ListTile(//display a structured row of information in a list. It’s typically used in menus, lists
                      title: Text('View Members'),
                      trailing: Icon(
                        Icons.group,//icon besed the view members
                        size: 16,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () async {
                      final membersId =
                          await groupProvider.fetchGroupUsers(widget.groupId);//send the group we want to bring its users ids
                      final List<UserModel> members = [];//list to take the members
                      for (var member in membersId) {//loop throw membersId
                        final user = await authProvider.fetchUserData(member);//send members id- resive user model (ALL USER INFO)
                        members.add(user!);//add them to the list
                        //MEMBERS CONTAINS ALL USER INFORMATIONS 
                      }
                      //** fetches the list of group members,
                      //and display them*/
                      if (context.mounted) {
                        showModalBottomSheet(// panel that comes up from the bottom of the screen. 
                          context: context,
                          builder: (context) {
                            return ListView.builder(//builds the items as they are scrolled into view.
                              padding: EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 8.0,
                              ),
                              itemCount: members.length,// list will display as many items as there are members in the members list.
                              itemBuilder: (context, index) {// called repeatedly for each item in the list 
                              // index is a zero-based integer that represents the position of the current item in the list.
                                return ListTile(// display the member's information
                                  leading: CircleAvatar(//leading widget is a CircleAvatar that displays the member's profile image
                                    backgroundImage: CachedNetworkImageProvider(// loads the member's profile image from a URL.
                                      members[index].profileUrl,
                                    ),
                                  ),
                                  title: Text(//displays the username of the member.
                                    members[index].username,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                  //**for deleting the group, done only by admin */
                  if (widget.adminId == authProvider.user!.uid)// if the current user (identified by authProvider.user!.uid) is the admin of the group.
                    PopupMenuItem(
                      child: const ListTile(// list tile widget that contains the text Delete Group and an icon (trash bin).
                        title: Text('Delete Group'),
                        trailing: Icon(
                          Icons.delete,
                          size: 16,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onTap: () {
                        groupProvider.deleteGroup(widget.groupId);//deletes the group from some data source.
                        Navigator.pop(context);
                      },
                    ),
                    //**for normal users, Exit the group */
                  if (widget.adminId != authProvider.user!.uid)
                    PopupMenuItem(
                      child: const ListTile(
                        title: Text('Exit Group'),
                        trailing: Icon(
                          Icons.logout,
                          size: 16,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onTap: () {
                        groupProvider.leaveGroup(
                          widget.groupId,
                          authProvider.user!.uid,
                        );
                        Navigator.pop(context);
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
      
      //** build the UI based on data coming from a stream.,every time new message added, will rebuild the stream   */
      body: StreamBuilder(
        stream: messageProvider.getGroupMessages(widget.groupId),//returns  messages for the group,UI will listen for any new messages in this group.
        builder: (context, AsyncSnapshot snapshot) {//builder function is called every time the stream emits new data
         //AsyncSnapshot that contains the current state of the stream (i.e., whether data is being loaded, or if data has been received)
          if (snapshot.connectionState == ConnectionState.waiting) {//still loading and has not yet provided data
            return Center(child: CircularProgressIndicator());//loading
          }

          if (!snapshot.hasData) {//f the stream returns no data
            return Center(child: Text("No messages"));//displays a message saying "No messages" to inform the user that there are no messages in the group
          }
          /*takes a list of Firestore document snapshots (which represent messages in a group chat)
          and transforms them into a list of custom ChatMessage */
          final messageDocs = snapshot.data.docs;//gives a list of documents(messages) fetched from Firestore.(for the group)
          //Each document represents a message in the group chat.
          List<ChatMessage> messages = messageDocs.map<ChatMessage>((doc) {//map will loop for each doc
            //loop for each Doc(message and take its info)
            Timestamp? timestamp = doc['timestamp'] as Timestamp?;
            DateTime messageTime = timestamp != null
                ? timestamp.toDate()
                : DateTime.now(); // Use current time as a fallback
            return ChatMessage(//Indivisual messages info
              user: ChatUser(
                id: doc['senderId'],// Extracts the sender's ID from the Firestore document.
                firstName: doc['senderName'],
                profileImage: doc['senderProfileImage'],
              ),
              text: doc['text'],
              createdAt: messageTime,
              customProperties: {
                'messageId': doc.id,// // Adds a custom property to the message object: the Firestore document's ID.
              },
            );
          }).toList();


          //**create a chat interface using a Stack widget that displays messages, allows message sending, 
          //and provides options for interaction like long-pressing on a message(report) */
          return Stack(//used to overlay multiple widgets on top of each other[back ground,chat UI]
           //Building the Chat UI
            children: [
              Container(// background
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.grey.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: DashChat(//actual chat UI (DashChat which build the chat interface) on top of it.
                  messageOptions: MessageOptions(// customizes the behavior of individual messages in the chat
                    showTime: true,//show the timestamp of each message
                    onLongPressMessage: (message) {//triggered when a user long-presses a message.
                     // report the message
                      _reportMessage(
                        message.customProperties!['messageId'],//customProperties:Map (or similar collection) that holds additional information
                        message.text,
                      );
                    },
                  ),
                  inputOptions: InputOptions(// options control the behavior of the text input field
                    alwaysShowSend: true,//ensures that the send button is always visible, even when the user is typing.
                    inputMaxLines: 3,// input field to expand up to 3 lines when the user types.
                  ),
                  currentUser: ChatUser(//represents the current user in the chat
                    id: authProvider.user!.uid,
                    firstName: authProvider.user!.displayName ?? "User",
                  ),
                  messages: messages.reversed.toList(),//list of messages that are passed to the DashChat widget
                  onSend: (ChatMessage message) {//triggered when the user sends a new message
                    if (message.text.trim().isEmpty) return;// checks if the message text is not empty
                    final user = authProvider.userModel!;//bring more info about the user 
                    messageProvider.sendMessage(//send the message
                      widget.groupId,
                      message.text.trim(),
                      user.id,
                      user.username,
                      user.profileUrl,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
