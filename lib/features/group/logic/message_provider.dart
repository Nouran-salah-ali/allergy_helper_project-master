import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class MessageProvider extends ChangeNotifier { //when a message is updated, added, or removed, the UI can listen to these changes and act on it.
  final _firestoreInstance = FirebaseFirestore.instance; //initializes a reference to Firestore's instance, which allows you to interact with the Firestore database.
  final _firebaseStorageInstance = FirebaseStorage.instance; //Firebase Storage for managing files associated with messages like photo.

  // Fetch messages of the group
  Stream<QuerySnapshot> getGroupMessages(String groupId) { //stream takes continues real time updated data - and query snapshot has list of messages from firestor.
    final result = _firestoreInstance
        .collection("groups")//everything bellow is stored in the groups collection; like when we see it in firebase.
        .doc(groupId)
        .collection("messages")//a sub collection and Each document inside it is all the messages.
        .orderBy("timestamp")//Sorts the messages in ascending order and ensures the messages are returned in chronological order.
        .snapshots();

    return result; //use the Stream to listen for updates, process the data, or display it in the UI, enabling responsive behavior.
  }
       //sending messages 
  Future<void> sendMessage(String groupId, String text, String senderId, //future means its asynchronous operation - and void means doesn't return any  value; it only sends messages.
      String senderName, String senderProfileImage,
      {String? imageUrl}) async {//** the ? means the image can be null.
      //*info about the message*
    final message = { //message to be stored in Firestore.
      "senderId": senderId,
      "senderName": senderName,
      "senderProfileImage": senderProfileImage,
      "text": text,
      "imageUrl": imageUrl,
      "timestamp": FieldValue.serverTimestamp(), //set the timestamp of the message to the current time as recorded by the server.
    };

    //*Add message to the messages sub collection within the group*
    await _firestoreInstance //pause the execution of an asynchronous function until a Future in line 12 completes.
        .collection("groups")
        .doc(groupId)//ensures the message is sent to the correct group.
        .collection("messages")
        .add(message);//Adds it as a new document to messages and Saves the message in the database and automatically generates a unique ID for it.

    //*Update the lastMessage and lastMessageTimestamp fields in the group document*
    await _firestoreInstance.collection("groups").doc(groupId).update({ //.update: Allows partial updates to a document without overwriting the entire document. so just updating the stuff inside it only.
      "lastMessage": text, //Stores the content of the latest message sent and display it in the app.
      "lastMessageTimestamp": FieldValue.serverTimestamp(), //same as line 31.
    });
  }
   //for uploading photo in chat ... we dont have this?? might remove
  Future<String> uploadImage(File image, String groupId) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final storageRef =
        _firebaseStorageInstance.ref().child("groups/$groupId/$fileName");

    await storageRef.putFile(image);

    return await storageRef.getDownloadURL();
  }
}
