import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'wiktionary_parser.dart' as wiktionary_parser;

void main() {
  print("Getting html...");
  http.get(Uri.parse("https://en.m.wiktionary.org/wiki/manger"))
    .then((html) => http.get(Uri.parse("https://en.m.wiktionary.org/w/load.php?lang=en&modules=ext.wikimediaBadges%7Cmediawiki.hlist%7Cmediawiki.ui.button%2Cicon%7Cmobile.init.styles%7Cskins.minerva.base.styles%7Cskins.minerva.content.styles.images%7Cskins.minerva.icons.wikimedia%7Cskins.minerva.mainMenu.icons%2Cstyles&only=styles&skin=minerva"))
      .then((css) =>
        runApp(MyApp(html.body.toString(), css.body.toString()))
      )
  );
}

class MyApp extends StatelessWidget {
  final String htmlData;
  final String cssData;

  MyApp(this.htmlData, this.cssData);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(htmlData, cssData, title: 'Wiktionary')
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.htmlData, this.cssData, {Key? key, required this.title}) : super(key: key);

  final String title;
  final String htmlData;
  final String cssData;

  @override
  _MyHomePageState createState() => _MyHomePageState(this.htmlData, this.cssData);
}

class _MyHomePageState extends State<MyHomePage> {
  final String htmlData;
  final String cssData;
  _MyHomePageState(this.htmlData, this.cssData);

  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlparser.parse(htmlData);
    wiktionary_parser.cleanDocument(document);
    wiktionary_parser.attachCss(document, cssData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_html Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: document.outerHtml,
          onLinkTap: (url, _, __, ___) {
            print("Tapped on $url...");
          }
        ),
      ),
    );
  }
}
