import 'package:flutter/material.dart';
AppBar buildAppBar(BuildContext context, {required String title}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: [
      Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
    ],
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
