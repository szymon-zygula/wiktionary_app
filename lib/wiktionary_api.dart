import 'wiktionary_parser.dart' as wiktionary_parser;

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'dart:convert';

const protocol = "https";
const wiktionaryDomain = "wiktionary.org";
const apiPath = "/w/api.php";
const apiOmnipresentParams = "format=json";
const apiGetLanguagesParams = "action=parse&prop=langlinks";

String getApiUrl(String langCode) {
  return "$protocol://$langCode.$wiktionaryDomain/$apiPath?$apiOmnipresentParams";
}

String getSiteUrl(String langCode) {
  return "$protocol://$langCode.$wiktionaryDomain/wiki/";
}

class LanguageDefinition {
  final String code;
  final String name;
  final String autonym;

  LanguageDefinition._(this.code, this.name, this.autonym);
  static LanguageDefinition fromUnparsed(dynamic apiObject) {
    return LanguageDefinition._(apiObject["lang"], apiObject["langname"], apiObject["autonym"]);
  }

  @override
  String toString() {
    return "$name ($code): $autonym";
  }
}

Future<List<LanguageDefinition>> getArticleLanguages(String lang, int pageid) async {
  String url = "${getApiUrl(lang)}&$apiGetLanguagesParams&pageid=$pageid";
  http.Response res = await http.get(Uri.parse(url));
  Map<String, dynamic> jsonRes = jsonDecode(res.body.toString());
  List<dynamic> unparsedLangs = jsonRes["parse"]["langlinks"];

  List<LanguageDefinition> langs = [];
  for(dynamic unparsedLang in unparsedLangs) {
    langs.add(LanguageDefinition.fromUnparsed(unparsedLang));
  }

  return langs;
}

Future<dom.Document> getArticle(String lang, String name) async {
  String url = "${getSiteUrl(lang)}$name";
  http.Response res = await http.get(Uri.parse(url));
  String body = res.body.toString();
  dom.Document document = htmlparser.parse(body);
  wiktionary_parser.cleanDocument(document);
  return document;
}

//TODO: https://en.wiktionary.org/w/api.php?action=opensearch&search=uberweisen
// Future<> search...











