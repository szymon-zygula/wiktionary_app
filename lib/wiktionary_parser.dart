import 'wiktionary_api.dart' as wiktionary_api;

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

void removeSelf(dom.Element element) {
  element.remove();
}

void attachCss(dom.Document document, String css) {
  dom.Element style = document.createElement("style");
  style.innerHtml = css;
  document.head!.append(style);
}

void removeAudioTags(dom.Document document) {
  document.getElementsByTagName("audio").forEach(removeSelf);
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

void extractOnlyChild(dom.Element element) {
  element.replaceWith(element.firstChild!);
}

void removeLazyLoadedImages(dom.Document document) {
  document.getElementsByClassName("lazy-image-placeholder").forEach(removeSelf);
}

void removeLinksFromImages(dom.Document document) {
  document.getElementsByClassName("image").forEach(extractOnlyChild);
}

void makeImageLinkAbsolute(dom.Element element) {
  element.attributes["src"] = wiktionary_api.protocol + ":" + element.attributes["src"]!;
}

void makeImageLinksAbsolute(dom.Document document) {
  document.getElementsByTagName("img").forEach(makeImageLinkAbsolute);
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

void cleanDocument(dom.Document document) {
  removeAudioTags(document);

  removeEditSections(document);
  removePageActionsMenu(document);

  removeScripts(document);
  extractNoscripts(document);

  removeExternalLinks(document);

  removeLazyLoadedImages(document);
  makeImageLinksAbsolute(document);
  removeLinksFromImages(document);

  removeWordOfTheDayInfo(document);
}
