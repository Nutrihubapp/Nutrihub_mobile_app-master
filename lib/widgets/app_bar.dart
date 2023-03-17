import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final double? elevation;
  @override
  final Size preferredSize;

  CustomAppBar({Key? key, required this.title, this.elevation = 1})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: widget.elevation,
      leading:    Platform.isIOS? IconButton(icon:const Icon(Icons.arrow_back_ios,color:kBackgroundColor), onPressed:()=>Navigator.pop(context)) : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Provider.of<Auth>(context, listen: false).changeAppBar(true);
            Navigator.pop(context);
          }),
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: kDetailsScreenColor,
      title: Text(widget.title,
          style: const TextStyle(

            color: Colors.white,
            fontSize: 18,
          )),
    );
  }
}
