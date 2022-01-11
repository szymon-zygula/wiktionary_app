import 'package:html/dom.dart' as dom;

import 'wiktionary_api.dart' as wiktionary_api;

String _getTitle(dom.Document document) {
  dom.Element firstHeading = document.getElementById('firstHeading')!;
  List<dom.Element> firstHeadingSpans =
      firstHeading.getElementsByTagName('span');

  if (firstHeadingSpans.isEmpty) {
    return firstHeading.innerHtml;
  } else {
    return firstHeadingSpans[0].innerHtml;
  }
}

void _removeNestedTables(dom.Document document) {
  List<dom.Element> tables =
      document.getElementsByClassName('inflection-table');

  for (dom.Element table in tables) {
    table.getElementsByClassName('inflection-table').forEach(_removeSelf);
  }
}

void _removeSelf(dom.Element element) {
  element.remove();
}

void _removeParent(dom.Element element) {
  element.parent!.remove();
}

void attachCss(dom.Document document, String css) {
  dom.Element style = document.createElement('style');
  style.innerHtml = css;
  document.head!.append(style);
}

void _extractContent(dom.Document document) {
  String articleText =
      document.getElementsByClassName('mw-parser-output').first.innerHtml;
  document.documentElement!.innerHtml = articleText;
}

void _removeAudio(dom.Document document) {
  document.getElementsByClassName('audiotable').forEach(_removeParent);
}

void _removeEditSections(dom.Document document) {
  document.getElementsByClassName('mw-editsection').forEach(_removeSelf);
}

void _removePageActionsMenu(dom.Document document) {
  document.getElementsByClassName('page-actions-menu').forEach(_removeSelf);
}

void _removeScripts(dom.Document document) {
  document.getElementsByTagName('script').forEach(_removeSelf);
}

void _convertTag(dom.Document document, dom.Element element, String newTag) {
  String innerHtml = element.innerHtml;
  dom.Element newElement = document.createElement(newTag);
  newElement.innerHtml = innerHtml;
  element.replaceWith(newElement);
}

void _removeExternalLinks(dom.Document document) {
  document
      .getElementsByClassName('extiw')
      .forEach((el) => _convertTag(document, el, 'span'));
}

void _removeNewArticleLinks(dom.Document document) {
  document
      .getElementsByClassName('new')
      .forEach((el) => _convertTag(document, el, 'span'));
}

void _removeAudiometa(dom.Document document) {
  document.getElementsByClassName('audiometa').forEach(_removeSelf);
}

void _extractOnlyChild(dom.Element element) {
  element.replaceWith(element.firstChild!);
}

void _removeLazyLoadedImages(dom.Document document) {
  document
      .getElementsByClassName('lazy-image-placeholder')
      .forEach(_removeSelf);
}

void _removeLinksFromImages(dom.Document document) {
  document.getElementsByClassName('image').forEach(_extractOnlyChild);
}

void _makeResourceLinkAbsolute(dom.Element element) {
  element.attributes['src'] =
      wiktionary_api.protocol + ':' + element.attributes['src']!;
}

void _makeResourceLinksAbsolute(dom.Document document) {
  document.getElementsByTagName('img').forEach(_makeResourceLinkAbsolute);
  document.getElementsByTagName('source').forEach(_makeResourceLinkAbsolute);
}

void extractNoscript(dom.Document document, dom.Element element) {
  String inner = element.innerHtml;
  String innerParsed = inner.replaceAll('&lt;', '<').replaceAll('&gt;', '>');

  dom.Element replacement = document.createElement('DIV');
  replacement.innerHtml = innerParsed;

  element.replaceWith(replacement);
}

void _extractNoscripts(dom.Document document) {
  document
      .getElementsByTagName('noscript')
      .forEach((el) => extractNoscript(document, el));
}

void _removeWordOfTheDayInfo(dom.Document document) {
  document.getElementsByClassName('was-wotd').forEach(_removeSelf);
}

void _removeNavigation(dom.Document document) {
  document.getElementsByClassName('toc').forEach(_removeSelf);
}

void _fixInlineBackgroundColor(dom.Document document) {
  String inner = document.documentElement!.innerHtml;
  String fixedInner = inner.replaceAll('background:', 'background-color:');
  document.documentElement!.innerHtml = fixedInner;
}

void _appendStyle(dom.Element element, String style) {
  String newStyle;
  if (element.attributes['style'] == null) {
    newStyle = '';
  } else {
    newStyle = element.attributes['style']! + ';';
  }

  element.attributes['style'] = newStyle + style + ';';
}

void _centerTableHeaders(dom.Document document) {
  document
      .getElementsByTagName('th')
      .forEach((el) => _appendStyle(el, 'text-align:center'));
}

void _styleTables(dom.Document document) {
  document
      .getElementsByTagName('table')
      .forEach((el) => _appendStyle(el, 'border: 1px solid black'));
  document
      .getElementsByTagName('th')
      .forEach((el) => _appendStyle(el, 'border: 1px solid black'));
  document
      .getElementsByTagName('td')
      .forEach((el) => _appendStyle(el, 'border: 1px solid black'));
  document
      .getElementsByTagName('tr')
      .forEach((el) => _appendStyle(el, 'border: 1px solid black'));
}

String _removeUnitsFromString(String str, String unit) {
  str = str.replaceAll(RegExp(r'width: ?\d+' + unit + ';?'), '');
  str = str.replaceAll(RegExp(r'height: ?\d+' + unit + ';?'), '');
  return str;
}

void _removeUnsupportedUnits(dom.Document document) {
  String inner = document.documentElement!.innerHtml;
  inner = _removeUnitsFromString(inner, 'em');
  inner = _removeUnitsFromString(inner, 'rem');
  inner = _removeUnitsFromString(inner, 'vh');
  inner = _removeUnitsFromString(inner, 'vw');
  document.documentElement!.innerHtml = inner;
}

String cleanDocument(dom.Document document) {
  String title = _getTitle(document);

  _extractContent(document);

  _removeAudio(document);

  _removeEditSections(document);
  _removePageActionsMenu(document);

  _removeScripts(document);
  _extractNoscripts(document);

  _removeExternalLinks(document);
  _removeNewArticleLinks(document);
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

  _removeNestedTables(document);

  return title;
}
