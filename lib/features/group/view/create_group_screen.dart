import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/group/logic/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);//AppAutProvider used to get the current user's information, like their uid
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);//GroupProvider  responsible for creating and managing groups
    final TextEditingController groupNameController = TextEditingController();//hold and manage the value that the user enters into the TextFormField FOR GROUB NAME.

    return Scaffold(
      appBar: AppBar(
        title: Text("Create new group"),//**title on the groube page */
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(//we want to fill the avalibal space for widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(// allows the user to input the group name
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      label: Text("Group name"),//**the  defalut name for the box*/
                    ),
                    controller: groupNameController,// controller for this input field, allowing the widget to retrieve the text the user enters.
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              onPressed: () {
                groupProvider.createGroup(
                  groupNameController.text,//takes the text on the text filled and make it text(group name)
                  authProvider.user!.uid,//retrieves the unique ID of the currently authenticated user
                );
                Navigator.pop(context);// pop the current screen off the navigation stack, which takes the user back to the previous screen.
              },
              child: Text("Create group"),//**button for creating the group */
            ),
          ],
        ),
      ),
    );
  }
}
