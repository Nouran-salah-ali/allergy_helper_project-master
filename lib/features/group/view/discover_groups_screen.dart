import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/group/logic/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverGroupsScreen extends StatefulWidget {
  const DiscoverGroupsScreen({super.key});

  @override
  State<DiscoverGroupsScreen> createState() => _DiscoverGroupsScreenState();
}
 // Tracks the user's search input
class _DiscoverGroupsScreenState extends State<DiscoverGroupsScreen> {
  String _searchQuery = "";//the search word the user enters is stored here.

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);//access objects provided by the auth, group Provider.
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);//listen: false: means that these widgets won't rebuild when the providers' state changes.

    return Scaffold(
      appBar: AppBar(//**design app bar at the top left of the screen.
        title: const Text("Discover"),//**the text that will show in the place of appbar.
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),//** the edges of the text box.
            child: TextField(//** text box view.
              decoration: InputDecoration(
                labelText: "Search groups",//** shows inside of the search textbox.
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {// Update the search query
                  _searchQuery = value.toLowerCase(); //method to convert to lowercase, making the search case-insensitive.
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(//used to asynchronously fetch data. It has a builder function, which reacts to changes in the Future’s state.
              future: groupProvider.getGroupsUserNotIn(authProvider.user!.uid),//a method in the GroupProvider class that fetches groups the user is not part of - and Retrieves the a user's unique ID.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {//the current state of the Future - and .waiting: means The Future is currently running but hasn’t completed.
                  return const Center(
                    child: CircularProgressIndicator(),//A built-in Flutter widget that displays an animated circular progress bar.
                  );
                }
               
                if (!snapshot.hasData || snapshot.data!.isEmpty) {//if data (groups) are not retrived yet and snapshot is null it will make it empty.
                  return const Center(
                    child: Text(
                      "No groups yet! Create your own group.",//** display when no group on screen.
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final groups = snapshot.data!;// make sure the data is not null.
                final filteredGroups = groups
                    .where((group) => group["name"]//Filters the groups list. and the arrow takes only items that meet the condition(takes only name from group coliction).
                        .toString()
                        .toLowerCase()//ensuring the search is case-insensitive
                        .contains(
                            _searchQuery)) //Checks if the string of the group's name contains the search query name(word).
                    .toList();//Converts the filtered results back into a list and stores it in filteredGroups.

                if (filteredGroups.isEmpty) {
                  return const Center(
                    child: Text(//** string when group is not found.
                      "No matching groups found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
              //**list of groups fetched by the Future.
                return ListView.builder( //display widgets for each group in the groups list.
                  itemCount: filteredGroups.length, //ensure every item in the groups list is represented in the ListView
                  itemBuilder: (context, index) {//A callback function that creates widgets for each group inside list. and is Called for each index from 0 to groups.length - 1.
                    final group = filteredGroups[index];
                    return Card(//widget container used for grouping related content, like the details of a single group(number of memebers).
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),//** the shape of every group box has circle corners.
                      ),
                      elevation: 2,//** Adds a shadow effect to the card, to look 3D.
                      margin: const EdgeInsets.symmetric(vertical: 6),//** Adds spacing between the groups.
                      child: ListTile(//widget for simple rows with icons and text, and is Used to organize and display group details.
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,//** color of the photo(avatar).
                          child: Text(
                            group["name"].substring(0, 1).toUpperCase(),//** Displays the first letter of the group's name in uppercase.
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          group["name"],//display group name.
                          style: const TextStyle(fontWeight: FontWeight.bold), //** Makes the group name bold.
                        ),
                        subtitle: Row(//Displays other info about the group below the name + row is used to combine everything neatly.
                          children: [
                            const Icon(Icons.person, size: 16),
                            Text(
                              "${group["membersCount"]} ",//Displays the count of members that are in the group.
                              overflow: TextOverflow.ellipsis, //Ensures that text is deleted if it overflows its container.
                              maxLines: 1,//** the text has only one line.
                            ),
                            const Text(
                              "members",//** add the word member in the box.
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        trailing: TextButton(//allows the user to join a group when clicked.
                          onPressed: () {
                            groupProvider.addMemberToGroup(//method in group provider that add the user to the group in firebase.
                                group.id, authProvider.user!.uid);
                            Navigator.pop(context);//Closes the current screen and shows the main groups screen.
                          },
                          child: const Text(
                            "Join",//** the word desplayed on the join button.
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
