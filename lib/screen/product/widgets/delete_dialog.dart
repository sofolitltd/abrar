// delete
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showDeleteDialog({
  required BuildContext context,
  required String id,
  required String collectionName,
}) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(); // Close the alert dialog
    },
  );

  //
  Widget continueButton = TextButton(
    child: const Text("Delete"),
    onPressed: () async {
      // Add logic to delete the item here
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .delete()
          .then((value) {
        Fluttertoast.showToast(msg: 'Delete successfully');
        Navigator.of(context).pop(); // Close the alert dialog
        if (collectionName != 'categories') {
          Navigator.of(context).pop(); // Close the alert dialog
        }
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Delete Confirmation"),
    content: const Text("Are you sure you want to delete this item?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
