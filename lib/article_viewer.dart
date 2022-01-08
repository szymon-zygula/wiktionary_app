import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'wiktionary_api.dart';

abstract class _ArticleViewEvent extends Equatable {
  const _ArticleViewEvent();
}

class _ArticleLoadedEvent extends _ArticleViewEvent {
  final dom.Document article;

  const _ArticleLoadedEvent(this.article);

  @override
  List<Object> get props => [article];
}

abstract class _ArticleViewBlocState extends Equatable {
  const _ArticleViewBlocState();
  Widget getWidget();
}

class _ArticleViewLoadingState extends _ArticleViewBlocState {
  const _ArticleViewLoadingState();

  @override
  List<Object> get props => [];

  @override
  Widget getWidget() {
    return const Expanded(
      child: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ArticleViewLoadedState extends _ArticleViewBlocState {
  final dom.Document article;
  const _ArticleViewLoadedState(this.article);

  @override
  List<Object> get props => [article];

  @override
  Widget getWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Html(
          data: article.documentElement!.innerHtml,
          onLinkTap: (url, _, __, ___) {
            print("Tapped on $url...");
          },
          customRender: {
            "table": (RenderContext context, Widget child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (context.tree as TableLayoutElement).toWidget(context),
              );
            },
          },
        ),
      ),
    );
  }
}

class _ArticleViewBloc extends Bloc<_ArticleViewEvent, _ArticleViewBlocState> {
  _ArticleViewBloc() : super(const _ArticleViewLoadingState()) {
    on<_ArticleLoadedEvent>(onLoad);
  }

  void onLoad(_ArticleLoadedEvent event, Emitter<_ArticleViewBlocState> emit) {
    emit(_ArticleViewLoadedState(event.article));
  }
}

class _ArticleView extends StatefulWidget {
  final String articleName;
  final String articleLanguage;

  const _ArticleView(this.articleLanguage, this.articleName);

  @override
  State<_ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<_ArticleView> {
  @override
  void initState() {
    getArticle(widget.articleLanguage, widget.articleName).then((doc) {
      BlocProvider.of<_ArticleViewBloc>(context).add(_ArticleLoadedEvent(doc));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_ArticleViewBloc, _ArticleViewBlocState>(
      builder: (context, _ArticleViewBlocState state) {
        return state.getWidget();
      },
    );
  }
}

class ArticleViewer extends StatelessWidget {
  final String articleLanguage;
  final String articleName;

  ArticleViewer(this.articleLanguage, this.articleName)
      : super(key: Key("ArticleViewer:$articleLanguage:$articleName"));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _ArticleViewBloc();
      },
      child: _ArticleView(articleLanguage, articleName),
    );
  }
}
