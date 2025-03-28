import 'package:flutter/material.dart';

Widget customButton(
    String text, Function fun, double width, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      fixedSize: Size(width, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    onPressed: () {
      fun();
    },
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    ),
  );
}




