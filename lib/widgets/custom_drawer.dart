import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skycast/core/constants/app_strings.dart';
import 'package:skycast/core/router/app_router.gr.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text(AppStrings.appName)),
          DrawerListTile(title: 'Favorites', icon: Icons.star, onTap: () => context.router.push(FavoritesRoute())),
          DrawerListTile(title: 'Settings', icon: Icons.settings, onTap: () => context.router.push(SettingsRoute())),
          DrawerListTile(title: 'About', icon: Icons.info, onTap: () {}),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const DrawerListTile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), leading: Icon(icon), onTap: onTap);
  }
}