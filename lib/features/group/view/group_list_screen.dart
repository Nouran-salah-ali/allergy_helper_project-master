import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/group/logic/group_provider.dart';
import 'package:allergy_helper_project/features/group/view/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
//**screen where users can see a list of groups they belong to. */
class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);

    if (authProvider.user == null) {//If the user is not authenticated,
      return Center(
        child: Text("User not authenticated"),
      );
    }

    return StreamBuilder(//listens to a stream, and its builder callback is called whenever there is a change in the data 
      stream: groupProvider.getUserGroups(authProvider.user!.uid),//groups the current user is part of,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {//loading screen
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {// If the snapshot doesn't contain any data or the list of groups is empty,
          return _buildEmptyState(context);//custom empty state message.
        }

        final groups = snapshot.data!.docs;//stream successfully returns data, the list of groups is extracted from the snapshot's docs

        //After extracting the groups, you would typically want to display them in a ListView
        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: groups.length,//Specifies the number of items (groups) in the list.
          itemBuilder: (context, index) { // Builds each item in the list
            final group = groups[index];// Accesses the group at the current index.
            final lastMessageTimestamp =
                group["lastMessageTimestamp"]?.toDate();// Gets the timestamp of the last message and converts it to a DateTime object.
            final lastMessageTime = lastMessageTimestamp != null // Formats the timestamp to a readable time format (e.g., "02:30 PM").
                ? DateFormat('hh:mm a').format(lastMessageTimestamp) 
                : "No recent messages";//If there is no timestamp,
            //**go to chat for selected group */
            return GestureDetector( // Detects when the user taps on any group .
              onTap: () {
                Navigator.push(// new screen in this case is the ChatScreen widget
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(//ChatScreen for the selected group
                      groupId: group.id,
                      adminId: group["groupAdmin"],
                      groupName: group["name"],
                    ),
                  ),
                );
              },
              //used for displaying grouped content like chats 
              child: Card(// visually distinct "box" for each group.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(//build the main layout of the card, which consists of the leading icon (circle avatar), title, subtitle.
                  leading: CircleAvatar(// circular avatar 
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      group["name"].substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.white),// Displays the first letter of the group's name, on icon
                    ),
                  ),
                  title: Text(//Displays the group’s name
                    group["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(//Displays the last message sent in the group
                    group["lastMessage"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Column(//Displays the last message time (formatted timestamp) on the right side of the card.
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        lastMessageTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,  // Centers the children vertically.
      children: [
        Text(
          "No chat groups available",// Main message informing the user there are no groups.
          textAlign: TextAlign.center,// Centers the text horizontally.
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        SizedBox(height: 10),
        GestureDetector(//wraps the "discover" section to make it interactive.
          onTap: () {
            Navigator.of(context).pushNamed("/discover_groups");//go to this page to find groups
          },
          child: Row(//display the "discover" text and the search icon horizontally next to each other.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "discover",//look like a clickable link.
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.search,
                size: 14,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
