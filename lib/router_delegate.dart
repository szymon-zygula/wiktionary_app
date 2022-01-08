import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'article_screen.dart';
import 'search_screen.dart';
import 'language_screen.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final _pages = <Page>[];

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route route, dynamic result) {
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length <= 1) {
      return Future.value(false);
    }

    _pages.removeLast();
    notifyListeners();
    return Future.value(true);
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
    throw UnimplementedError();
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;
    switch (routeSettings.name) {
      case '/main':
        child = const MainScreen();
        break;
      case '/article':
        final Map<String, String> args =
            routeSettings.arguments as Map<String, String>;

        child = ArticleScreen(
          language: args['language']!,
          articleName: args['articleName']!,
        );
        break;
      case '/search':
        child = const SearchScreen();
        break;
      case '/language':
        final Map<String, String> args =
            routeSettings.arguments as Map<String, String>;

        child = LanguageScreen(
          articleLanguage: args['articleLanguage']!,
          articleName: args['articleName']!,
        );
        break;
      default:
        throw "Invalid route selected!";
    }

    return MaterialPage(
      child: child,
      key: ValueKey(routeSettings.name),
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  void pushPage(String name, {dynamic arguments}) {
    _pages.add(_createPage(
      RouteSettings(name: name, arguments: arguments),
    ));

    notifyListeners();
  }
}
