import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/Widgets/BottomToTop.dart';
import 'package:notes/main.dart';

import '../home.dart';
import '../main.dart';
import '../notes.dart';

Widget buildTheme(BuildContext context, String image, String text, String words,
    String theme) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BottomToTopPageRoute(
            page: notes(
              title: "Add Note",
              theme: theme,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 1 / 3,
            width: MediaQuery.of(context).size.width * 1 / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              color: Color.fromARGB(255, 157, 191, 214),
              image: DecorationImage(
                image: AssetImage("assets/${image}"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: Text(words)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1 / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 10, // Blur radius
                  offset: Offset(0, 5), // Changes position of shadow
                ),
              ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text(text)]),
          )
        ],
      ));
}
