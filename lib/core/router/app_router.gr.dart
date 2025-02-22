// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:skycast/view/favorites/favorites_screen.dart' as _i1;
import 'package:skycast/view/home/home_screen.dart' as _i2;
import 'package:skycast/view/settings/settings_screen.dart' as _i3;

/// generated route for
/// [_i1.FavoritesScreen]
class FavoritesRoute extends _i4.PageRouteInfo<void> {
  const FavoritesRoute({List<_i4.PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.FavoritesScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i5.Key? key, List<_i4.PageRouteInfo>? children})
    : super(
        HomeRoute.name,
        args: HomeRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i2.HomeScreen(key: args.key);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.SettingsScreen]
class SettingsRoute extends _i4.PageRouteInfo<void> {
  const SettingsRoute({List<_i4.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.SettingsScreen();
    },
  );
}
