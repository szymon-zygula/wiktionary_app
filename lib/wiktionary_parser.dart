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

void extractContent(dom.Document document) {
  String articleText = document.getElementsByClassName("mw-parser-output").first.innerHtml;
  document.documentElement!.innerHtml = articleText;
}

void removeAudio(dom.Document document) {
  document.getElementsByClassName("audiotable").forEach(removeParent);
}

void removeEditSections(dom.Document document) {
  document.getElementsByClassName("mw-editsection").forEach(removeSelf);
}

void removePageActionsMenu(dom.Document document) {
  document.getElementsByClassName("page-actions-menu").forEach(removeSelf);
}

void removeScripts(dom.Document document) {
  document.getElementsByTagName("script").forEach(removeSelf);
}

void convertTag(dom.Document document, dom.Element element, String newTag) {
  String innerHtml = element.innerHtml;
  dom.Element newElement = document.createElement(newTag);
  newElement.innerHtml = innerHtml;
  element.replaceWith(newElement);
}

void removeExternalLinks(dom.Document document) {
  document.getElementsByClassName("extiw").forEach((el) => convertTag(document, el, 'span'));
}

void removeAudiometa(dom.Document document) {
  document.getElementsByClassName("audiometa").forEach(removeSelf);
}

void extractOnlyChild(dom.Element element) {
  element.replaceWith(element.firstChild!);
}

void removeLazyLoadedImages(dom.Document document) {
  document.getElementsByClassName("lazy-image-placeholder").forEach(removeSelf);
}

void removeLinksFromImages(dom.Document document) {
  document.getElementsByClassName("image").forEach(extractOnlyChild);
}

void makeResourceLinkAbsolute(dom.Element element) {
  element.attributes["src"] = wiktionary_api.protocol + ":" + element.attributes["src"]!;
}

void makeResourceLinksAbsolute(dom.Document document) {
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

void extractNoscripts(dom.Document document) {
  document.getElementsByTagName("noscript").forEach((el) => extractNoscript(document, el));
}

void removeWordOfTheDayInfo(dom.Document document) {
  document.getElementsByClassName("was-wotd").forEach(removeSelf);
}

void removeNavigation(dom.Document document) {
  document.getElementsByClassName("toc").forEach(removeSelf);
}

void fixInlineBackgroundColor(dom.Document document) {
  String inner = document.documentElement!.innerHtml;
  String fixedInner = inner.replaceAll("background:", "background-color:");
  document.documentElement!.innerHtml = fixedInner;
}

void appendStyle(dom.Element element, String style) {
  String newStyle;
  if(element.attributes['style'] == null) {
    newStyle = "";
  }
  else {
    newStyle = element.attributes['style']! + ";";
  }

  element.attributes['style'] = newStyle + style + ";";
}

void centerTableHeaders(dom.Document document) {
  document.getElementsByTagName("th")
    .forEach((el) => appendStyle(el, "text-align:center"));
}

void styleTables(dom.Document document) {
  document.getElementsByTagName("table")
    .forEach((el) => appendStyle(el, "border: 1px solid black"));
  document.getElementsByTagName("th")
    .forEach((el) => appendStyle(el, "border: 1px solid black"));
  document.getElementsByTagName("td")
    .forEach((el) => appendStyle(el, "border: 1px solid black"));
  document.getElementsByTagName("tr")
    .forEach((el) => appendStyle(el, "border: 1px solid black"));
}

void cleanDocument(dom.Document document) {
  extractContent(document);

  removeAudio(document);

  removeEditSections(document);
  removePageActionsMenu(document);

  removeScripts(document);
  extractNoscripts(document);

  removeExternalLinks(document);
  removeAudiometa(document);

  removeLazyLoadedImages(document);
  makeResourceLinksAbsolute(document);
  removeLinksFromImages(document);

  removeWordOfTheDayInfo(document);

  removeNavigation(document);

  fixInlineBackgroundColor(document);
  centerTableHeaders(document);
  styleTables(document);
}
