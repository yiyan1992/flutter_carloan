import 'package:flutter/material.dart';

class MeCell extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconName;
  final String title;

  MeCell({this.title, this.iconName, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Image.asset(iconName),
                  SizedBox(width: 20),
                  Text(title, style: TextStyle(fontSize: 14)),
                  Expanded(child: Container()),
                  Image.asset('assets/images/arrow_right.png'),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
              margin: EdgeInsets.only(left: 0),
            ),
          ],
        ),
      ),
    );
  }
}
