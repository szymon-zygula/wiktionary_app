import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  runApp(WiktionaryApp(Get.put(localStorage)));
}

class WiktionaryApp extends StatelessWidget {
  final MyRouterDelegate routerDelegate = Get.put(MyRouterDelegate());
  final SharedPreferences localStorage;

  WiktionaryApp(this.localStorage) : super(key: const Key('MyApp')) {
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
