import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      supportedLocales: const [
        Locale('en', ''),
        Locale('pl', ''),
        Locale('de', ''),
        Locale('fr', ''),
        Locale('it', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
    );
  }
}
