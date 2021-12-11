import 'wiktionary_api.dart' as wiktionary_api;

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

void removeSelf(dom.Element element) {
  element.remove();
}

void removeParent(dom.Element element) {
  element.parent!.remove();
}

void attachCss(dom.Document document, String css) {
  dom.Element style = document.createElement("style");
  style.innerHtml = css;
  document.head!.append(style);
}

void _extractContent(dom.Document document) {
  String articleText =
      document.getElementsByClassName("mw-parser-output").first.innerHtml;
  document.documentElement!.innerHtml = articleText;
}

void _removeAudio(dom.Document document) {
  document.getElementsByClassName("audiotable").forEach(removeParent);
}

void _removeEditSections(dom.Document document) {
  document.getElementsByClassName("mw-editsection").forEach(removeSelf);
}

void _removePageActionsMenu(dom.Document document) {
  document.getElementsByClassName("page-actions-menu").forEach(removeSelf);
}

void _removeScripts(dom.Document document) {
  document.getElementsByTagName("script").forEach(removeSelf);
}

void convertTag(dom.Document document, dom.Element element, String newTag) {
  String innerHtml = element.innerHtml;
  dom.Element newElement = document.createElement(newTag);
  newElement.innerHtml = innerHtml;
  element.replaceWith(newElement);
}

void _removeExternalLinks(dom.Document document) {
  document
      .getElementsByClassName("extiw")
      .forEach((el) => convertTag(document, el, 'span'));
}

void _removeAudiometa(dom.Document document) {
  document.getElementsByClassName("audiometa").forEach(removeSelf);
}

void extractOnlyChild(dom.Element element) {
  element.replaceWith(element.firstChild!);
}

void _removeLazyLoadedImages(dom.Document document) {
  document.getElementsByClassName("lazy-image-placeholder").forEach(removeSelf);
}

void _removeLinksFromImages(dom.Document document) {
  document.getElementsByClassName("image").forEach(extractOnlyChild);
}

void makeResourceLinkAbsolute(dom.Element element) {
  element.attributes["src"] =
      wiktionary_api.protocol + ":" + element.attributes["src"]!;
}

void _makeResourceLinksAbsolute(dom.Document document) {
  document.getElementsByTagName("img").forEach(makeResourceLinkAbsolute);
  document.getElementsByTagName("source").forEach(makeResourceLinkAbsolute);
}

void extractNoscript(dom.Document document, dom.Element element) {
  String inner = element.innerHtml;
  String innerParsed = inner.replaceAll("&lt;", "<").replaceAll("&gt;", ">");

  dom.Element replacement = document.createElement("DIV");
  replacement.innerHtml = innerParsed;

  element.replaceWith(replacement);
}

void _extractNoscripts(dom.Document document) {
  document
      .getElementsByTagName("noscript")
      .forEach((el) => extractNoscript(document, el));
}

void _removeWordOfTheDayInfo(dom.Document document) {
  document.getElementsByClassName("was-wotd").forEach(removeSelf);
}

void _removeNavigation(dom.Document document) {
  document.getElementsByClassName("toc").forEach(removeSelf);
}

void _fixInlineBackgroundColor(dom.Document document) {
  String inner = document.documentElement!.innerHtml;
  String fixedInner = inner.replaceAll("background:", "background-color:");
  document.documentElement!.innerHtml = fixedInner;
}

void appendStyle(dom.Element element, String style) {
  String newStyle;
  if (element.attributes['style'] == null) {
    newStyle = "";
  } else {
    newStyle = element.attributes['style']! + ";";
  }

  element.attributes['style'] = newStyle + style + ";";
}

void _centerTableHeaders(dom.Document document) {
  document
      .getElementsByTagName("th")
      .forEach((el) => appendStyle(el, "text-align:center"));
}

void _styleTables(dom.Document document) {
  document
      .getElementsByTagName("table")
      .forEach((el) => appendStyle(el, "border: 1px solid black"));
  document
      .getElementsByTagName("th")
      .forEach((el) => appendStyle(el, "border: 1px solid black"));
  document
      .getElementsByTagName("td")
      .forEach((el) => appendStyle(el, "border: 1px solid black"));
  document
      .getElementsByTagName("tr")
      .forEach((el) => appendStyle(el, "border: 1px solid black"));
}

String removeUnitsFromString(String str, String unit) {
  str = str.replaceAll(RegExp(r'width: ?\d+' + unit + ';?'), '');
  str = str.replaceAll(RegExp(r'height: ?\d+' + unit + ';?'), '');
  return str;
}

void _removeUnsupportedUnits(dom.Document document) {
  String inner = document.documentElement!.innerHtml;
  inner = removeUnitsFromString(inner, 'em');
  inner = removeUnitsFromString(inner, 'rem');
  inner = removeUnitsFromString(inner, 'vh');
  inner = removeUnitsFromString(inner, 'vw');
  document.documentElement!.innerHtml = inner;
}

void cleanDocument(dom.Document document) {
  _extractContent(document);

  _removeAudio(document);

  _removeEditSections(document);
  _removePageActionsMenu(document);

  _removeScripts(document);
  _extractNoscripts(document);

  _removeExternalLinks(document);
  _removeAudiometa(document);

  _removeLazyLoadedImages(document);
  _makeResourceLinksAbsolute(document);
  _removeLinksFromImages(document);

  _removeWordOfTheDayInfo(document);

  _removeNavigation(document);

  _fixInlineBackgroundColor(document);
  _centerTableHeaders(document);
  _styleTables(document);

  _removeUnsupportedUnits(document);
}
