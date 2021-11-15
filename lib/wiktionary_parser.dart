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

void makeImageLinkAbsolute(dom.Element element) {
  element.attributes["src"]!.substring(2);
}

void makeImageLinksAbsolute(dom.Document document) {
  document.getElementsByTagName("img").forEach(makeImageLinkAbsolute);
}

void cleanDocument(dom.Document document) {
  removeAudioTags(document);
  removeEditSections(document);
  removePageActionsMenu(document);
  removeScripts(document);
  removeExternalLinks(document);
  makeImageLinksAbsolute(document);
}
