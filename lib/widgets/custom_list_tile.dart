import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.title, required this.icon, this.value = ""});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final trailing = value.isEmpty ? Icon(Icons.arrow_right) : Text(value);
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      titleTextStyle: const TextStyle(fontSize: 20),
      leadingAndTrailingTextStyle: const TextStyle(fontSize: 18),
    );
  }
}