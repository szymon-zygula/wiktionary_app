import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'router_delegate.dart';
import 'wiktionary_api.dart';
import 'generic_entry_list.dart';
import 'custom_buttons.dart';

abstract class _LanguageListEvent extends Equatable {
  const _LanguageListEvent();
}

class _LanguageListLoadedEvent extends _LanguageListEvent {
  final List<LanguageDefinition> languages;
  final String? articleName;
  final Function(String)? insteadOfNavigation;

  const _LanguageListLoadedEvent(
      this.articleName, this.languages, this.insteadOfNavigation);

  @override
  List<Object> get props => [languages];
}

abstract class _LanguageListBlocState extends Equatable {
  const _LanguageListBlocState();
  Widget getWidget();
}

class LanguageListLoadingState extends _LanguageListBlocState {
  const LanguageListLoadingState();

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

class _LanguageListLoadedState extends _LanguageListBlocState {
  final String? articleName;
  final List<LanguageDefinition> languages;
  final Function(String)? insteadOfNavigation;
  const _LanguageListLoadedState(
      this.articleName, this.languages, this.insteadOfNavigation);

  @override
  List<Object> get props => [languages];

  @override
  Widget getWidget() {
    return GenericEntryList(
      languages
          .map((language) => '${language.autonym} (${language.name})')
          .toList(),
      languages.map((language) => language.code).toList(),
      onTap: (lang) {
        MyRouterDelegate routerDelegate = Get.find();
        routerDelegate.popRoute(); // Pop language screen

        if (insteadOfNavigation != null) {
          insteadOfNavigation!(lang as String);
          return;
        }

        routerDelegate.popRoute(); // Pop article screen in previous laguage
        Map<String, String?> args = {
          'language': lang as String,
          'articleName': articleName,
        };
        routerDelegate.pushPage(
          '/article',
          arguments: args,
        );
      },
    );
  }
}

class _LanguageListBloc
    extends Bloc<_LanguageListEvent, _LanguageListBlocState> {
  _LanguageListBloc() : super(const LanguageListLoadingState()) {
    on<_LanguageListLoadedEvent>(onLoad);
  }

  void onLoad(
      _LanguageListLoadedEvent event, Emitter<_LanguageListBlocState> emit) {
    emit(_LanguageListLoadedState(
        event.articleName, event.languages, event.insteadOfNavigation));
  }
}

class _LanguageList extends StatefulWidget {
  final String? articleName;
  final String articleLanguage;
  final Function(String)? insteadOfNavigation;

  const _LanguageList(
      this.articleLanguage, this.articleName, this.insteadOfNavigation);

  @override
  State<_LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<_LanguageList> {
  @override
  void initState() {
    getArticleLanguages(widget.articleLanguage, widget.articleName)
        .then((languages) {
      BlocProvider.of<_LanguageListBloc>(context).add(_LanguageListLoadedEvent(
          widget.articleName, languages, widget.insteadOfNavigation));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_LanguageListBloc, _LanguageListBlocState>(
      builder: (context, _LanguageListBlocState state) {
        return state.getWidget();
      },
    );
  }
}

class _HeaderBarWithBackButton extends StatelessWidget {
  const _HeaderBarWithBackButton()
      : super(key: const Key('_HeaderBarWithBackButton'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: const [
          CustomBackButton(),
          _HeaderBar(),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar() : super(key: const Key('_HeaderBar'));

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          AppLocalizations.of(context)!.availableLanguages,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  final String articleLanguage;
  final String? articleName;
  final Function(String)? insteadOfNavigation;

  LanguageScreen(
      {required this.articleLanguage,
      required this.articleName,
      this.insteadOfNavigation})
      : super(key: Key('LanguageScreen:$articleLanguage:$articleName'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderBarWithBackButton(),
        BlocProvider(
          create: (context) {
            return _LanguageListBloc();
          },
          child:
              _LanguageList(articleLanguage, articleName, insteadOfNavigation),
        )
      ],
    );
  }
}
