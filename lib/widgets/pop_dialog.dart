import 'package:checkout_app/screens/auth_screen.dart';
import 'package:checkout_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class PopDialog {
  static buildPopupDialog(BuildContext context, items) {
    var msg = items['message'];
    var status = items['status'];
    if (status == 403) {
      var msg = "You are not signed in. Sign in to continue?";
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Notifying'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(msg),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Close'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Sign in'),
            ),
          ],
        ),
      );
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Notifying'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(msg),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static buildPopupDialog2(BuildContext context, items) {
    var msg = items['message'];
    var status = items['status'];
    if (status == 403) {
      var msg = "You are not signed in. Sign in to continue?";
      return AlertDialog(
        title: const Text('Notifying'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(msg),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Sign in'),
          ),
        ],
      );
    }
    return AlertDialog(
      title: const Text('Notifying'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(msg),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Go to Cart'),
        ),
      ],
    );
  }
}
