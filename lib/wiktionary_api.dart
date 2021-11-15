import 'package:http/http.dart' as http;
import 'dart:convert';

const protocol = "https";
const apiDomain = "wiktionary.org";
const apiPath = "/w/api.php";
const apiOmnipresentParams = "format=json";
const apiGetLanguagesParams = "action=parse&prop=langlinks";

String getApiUrl(String langCode) {
  return "$protocol://$langCode.$apiDomain/$apiPath?$apiOmnipresentParams";
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

Future<List<LanguageDefinition>> getArticleLanguages(int pageid) async {
  String url = "${getApiUrl("en")}&$apiGetLanguagesParams&pageid=$pageid";
  http.Response res = await http.get(Uri.parse(url));
  Map<String, dynamic> jsonRes = jsonDecode(res.body.toString());
  List<dynamic> unparsedLangs = jsonRes["parse"]["langlinks"];

  List<LanguageDefinition> langs = [];
  for(dynamic unparsedLang in unparsedLangs) {
    langs.add(LanguageDefinition.fromUnparsed(unparsedLang));
  }

  return langs;
}
