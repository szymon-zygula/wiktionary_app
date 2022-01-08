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
const apiSearchParams = "action=opensearch";

String _getApiUrl(String langCode) {
  return "$protocol://$langCode.$wiktionaryDomain/$apiPath?$apiOmnipresentParams";
}

String _getSiteUrl(String langCode) {
  return "$protocol://$langCode.$wiktionaryDomain/wiki/";
}

class LanguageDefinition {
  final String code;
  final String name;
  final String autonym;

  LanguageDefinition._(this.code, this.name, this.autonym);
  static LanguageDefinition fromUnparsed(dynamic apiObject) {
    return LanguageDefinition._(
        apiObject["lang"], apiObject["langname"], apiObject["autonym"]);
  }

  @override
  String toString() {
    return "$name ($code): $autonym";
  }
}

Future<dynamic> _getJson(String url) async {
  http.Response res = await http.get(Uri.parse(url));
  dynamic jsonRes = jsonDecode(res.body.toString());
  return jsonRes;
}

Future<List<LanguageDefinition>> getArticleLanguages(
    String lang, String page) async {
  String url = "${_getApiUrl(lang)}&$apiGetLanguagesParams&page=$page";
  Map<String, dynamic> jsonRes = await _getJson(url);
  List<dynamic> unparsedLangs = jsonRes["parse"]["langlinks"];

  List<LanguageDefinition> langs = [];
  for (dynamic unparsedLang in unparsedLangs) {
    langs.add(LanguageDefinition.fromUnparsed(unparsedLang));
  }

  return langs;
}

Future<dom.Document> getArticle(String lang, String name) async {
  String url = "${_getSiteUrl(lang)}$name";
  http.Response res = await http.get(Uri.parse(url));
  String body = res.body.toString();
  dom.Document document = htmlparser.parse(body);
  wiktionary_parser.cleanDocument(document);
  return document;
}

Future<List<String>> getSearchResults(String lang, String query) async {
  String url = "${_getApiUrl(lang)}&$apiSearchParams&search=$query";
  try {
    List<dynamic> jsonRes = await _getJson(url);
    List<String> results =
        (jsonRes[1] as List<dynamic>).map((lang) => (lang as String)).toList();
    return results;
  } catch (_) {
    return [];
  }
}
