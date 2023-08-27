import 'package:amazon_bookstore/ProductListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutStatusPopup extends StatelessWidget {
  final bool status;
  const CheckoutStatusPopup(this.status);

  @override
  Widget build(BuildContext context) {
    return status ? AlertDialog(
      title: Text('Success'),
      content: Text('The Order is placed'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    ) : AlertDialog(
      title: Text('Error!!!'),
      content: Text('Try Again later'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    );;
  }
}
