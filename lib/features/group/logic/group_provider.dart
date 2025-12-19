import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//**to work with data that are related to database for the groups */
class GroupProvider extends ChangeNotifier {//when a groupe is updated, added, or removed, the UI can listen to these changes and act on it.
  final _firestoreInstance = FirebaseFirestore.instance;// initializes a reference to Firestore's instance, which allows you to interact with the Firestore database.

  // Fetch chat groups where the current user is a member
  Stream<QuerySnapshot> getUserGroups(String userId) {//Stream<QuerySnapshot>, Firestore snapshot stream that emits real-time updates
    final result = _firestoreInstance
        .collection("groups")
        .where("members", arrayContains: userId)//filters the groups to only those where the members field contains the userId
        .where("isDeleted", isEqualTo: false)//ensures that only groups that are not marked as deleted are fetched
        .orderBy("lastMessageTimestamp", descending: true)//groups with the most recent activity are returned first.
        .snapshots();//makes the query real-time, updated query snapshots whenever the data changes (for example, when a new user joins a group, a group is deleted, or a message is sent)

    return result;
  }
   //Fetch chat groups where the current user is not a member
  Future<List<DocumentSnapshot>> getGroupsUserNotIn(String userId) async {//performs operations that may take time and returns a Future that eventually resolves to a list of DocumentSnapshots.
    // Step 1: Fetch all groups
    QuerySnapshot snapshot = await _firestoreInstance
        .collection("groups")//accesses Firestore collection called "groups"
        .where("isDeleted", isEqualTo: false)
        .get();

    // Step 2: Filter groups where the user is not a member
    List<DocumentSnapshot> groupsUserNotIn = snapshot.docs.where((doc) {
      List<dynamic> members = doc['members'];
      return !members.contains(userId);//will return all group that does not have this spesific member. in form of LIST, if true user not in groupe
    }).toList();

    return groupsUserNotIn;
  }

  // Create a new group with specified members
  Future<String> createGroup(String groupName, String adminId) async {//groupName:String name of the group.adminId: A String ID of user who will be the admin of the group.
    final groupRef = await _firestoreInstance.collection("groups").add(//add method used to create new document in the groups collection
          ({
            "name": groupName,// value passed in the groupName parameter.
            "members": [adminId],//list that initially contains only the adminId, indicating that the admin is the first member of the group.
            "groupAdmin": adminId,//value passed in the adminId parameter.
            "lastMessage": "No messages yet",
            "isDeleted": false,// indicates whether the group has been deleted. Initially, it's set to false.
            "membersCount": 1,
            "lastMessageTimestamp": FieldValue.serverTimestamp(),//Firestore timestamp stores time when last message was sent.
          }),
        );
    return groupRef.id;// String unique ID of the newly created group document from Firestore.
  }

  // Add a member to an existing group
  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestoreInstance.collection("groups").doc(groupId).update(//groupId is a unique identifier for the group document, 
          ({//.update() method is used to update the existing document with new data
            "members": FieldValue.arrayUnion([userId]),//adds the userId to the members array, but only if the userId does not already exist in the array
            "membersCount": FieldValue.increment(1),
          }),
        );
  }

  // Remove a user from the group (leaving the group)
  Future<void> leaveGroup(String groupId, String userId) async {
    await _firestoreInstance.collection("groups").doc(groupId).update(
          ({
            "members": FieldValue.arrayRemove([userId]),
            "membersCount": FieldValue.increment(-1),
          }),
        );
  }
//delete group
  Future<void> deleteGroup(String groupId) async {
    await _firestoreInstance.collection("groups").doc(groupId).update(
          ({
            "isDeleted": true,
          }),
        );
  }
//fetches the list of users (i.e., their user IDs) from a specific group in Firestore.
  Future<List<String>> fetchGroupUsers(String groupId) async {
    List<String> members = [];
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .get();

    if (groupDoc.exists) {// if the document with the given groupId exists in Firestore.
      List<dynamic> membersData = groupDoc.get("members") ?? [];//retrieves the value of the members field, ?? []: This is a null-coalescing operator. If the members field does not exist or is null, it defaults to an empty list ([]).
      members = List<String>.from(membersData);// converts  membersData into a List<String>
    }
    return members;
  }


}
