import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'wiktionary_api.dart';
import 'generic_entry_list.dart';
import 'custom_buttons.dart';

abstract class _LanguageListEvent extends Equatable {
  const _LanguageListEvent();
}

class _LanguageListLoadedEvent extends _LanguageListEvent {
  final List<LanguageDefinition> languages;

  const _LanguageListLoadedEvent(this.languages);

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
  final List<LanguageDefinition> languages;
  const _LanguageListLoadedState(this.languages);

  @override
  List<Object> get props => [languages];

  @override
  Widget getWidget() {
    return GenericEntryList(
      languages
          .map((language) => "${language.autonym} (${language.name})")
          .toList(),
      languages,
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
    emit(_LanguageListLoadedState(event.languages));
  }
}

class _LanguageList extends StatefulWidget {
  final String articleName;
  final String articleLanguage;

  const _LanguageList(this.articleLanguage, this.articleName);

  @override
  State<_LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<_LanguageList> {
  @override
  void initState() {
    getArticleLanguages(widget.articleLanguage, widget.articleName)
        .then((languages) {
      BlocProvider.of<_LanguageListBloc>(context)
          .add(_LanguageListLoadedEvent(languages));
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
        child: const Text(
          'Available languages',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  final String articleLanguage;
  final String articleName;

  LanguageScreen({required this.articleLanguage, required this.articleName})
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
          child: _LanguageList(articleLanguage, articleName),
        )
      ],
    );
  }
}
