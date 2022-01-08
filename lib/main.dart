import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'router_delegate.dart';

void main() async {
  runApp(WiktionaryApp());
}

class WiktionaryApp extends StatelessWidget {
  final routerDelegate = Get.put(MyRouterDelegate());

  WiktionaryApp() : super(key: const Key('MyApp')) {
    routerDelegate.pushPage('/main');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Router(
            routerDelegate: routerDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        ),
      ),
    );
  }
}
