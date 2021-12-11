import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'wiktionary_api.dart';
import 'search_bar.dart';
import 'custom_buttons.dart';
import 'debug.dart';

abstract class ArticleViewEvent extends Equatable {
  const ArticleViewEvent();
}

class ArticleLoadedEvent extends ArticleViewEvent {
  final dom.Document article;

  const ArticleLoadedEvent(this.article);

  @override
  List<Object> get props => [article];
}

abstract class ArticleViewState extends Equatable {
  const ArticleViewState();
  Widget getWidget();
}

class ArticleViewLoadingState extends ArticleViewState {
  const ArticleViewLoadingState();

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

class ArticleViewLoadedState extends ArticleViewState {
  final dom.Document article;
  const ArticleViewLoadedState(this.article);

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

class ArticleViewBloc extends Bloc<ArticleViewEvent, ArticleViewState> {
  ArticleViewBloc() : super(const ArticleViewLoadingState()) {
    on<ArticleLoadedEvent>(onLoad);
  }

  void onLoad(ArticleLoadedEvent event, Emitter<ArticleViewState> emit) {
    emit(ArticleViewLoadedState(event.article));
  }
}

class ArticleView extends StatefulWidget {
  final String articleName;
  final String articleLanguage;

  ArticleView(this.articleLanguage, this.articleName);

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  void initState() {
    getArticle(widget.articleLanguage, widget.articleName).then((doc) {
      print("loaded article");
      BlocProvider.of<ArticleViewBloc>(context).add(ArticleLoadedEvent(doc));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleViewBloc, ArticleViewState>(
      builder: (context, ArticleViewState state) {
        return state.getWidget();
      },
    );
  }
}

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building screen");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarWithButtons(),
        BlocProvider(
          create: (context) {
            print("Creating bloc provider");
            return ArticleViewBloc();
          },
          child: ArticleView('en', 'pies'),
        ),
      ],
    );
  }
}

class SearchBarWithButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CustomBackButton(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SearchBar(),
            ),
          ),
          CustomButton(Icons.language, () {
            showSnackBar(context, 'Changement de la langue !');
          }),
        ],
      ),
    );
  }
}
