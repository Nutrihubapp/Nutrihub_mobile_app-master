import 'package:flutter/material.dart';

class HelpAndSupportList extends StatefulWidget {
  final String? systemEmail;
  final String? systemPhone;
  final String? helpAndSupportId;
  final String? question;
  final String? answer;
  final String? status;

  const HelpAndSupportList(
      {Key? key,
      this.systemEmail,
      this.systemPhone,
      this.helpAndSupportId,
      this.question,
      this.answer,
      this.status})
      : super(key: key);

  @override
  _HelpAndSupportListState createState() => _HelpAndSupportListState();
}

class _HelpAndSupportListState extends State<HelpAndSupportList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ListTile(
                title: Text(
                  'Q.' +
                      widget.helpAndSupportId.toString() +
                      ' ' +
                      widget.question.toString(),
                  style: const TextStyle(),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Ans. ' + widget.answer.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
