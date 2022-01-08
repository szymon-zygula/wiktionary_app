import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'router_delegate.dart';
import 'search_bar.dart';
import 'generic_entry_list.dart';
import 'custom_buttons.dart';
import 'wiktionary_api.dart';

abstract class _SearchScreenEvent extends Equatable {
  const _SearchScreenEvent();
}

class _SearchPerformed extends _SearchScreenEvent {
  final String language;
  final String query;

  const _SearchPerformed(this.query, this.language);

  @override
  List<Object> get props => [query];
}

class _SearchLoaded extends _SearchScreenEvent {
  final String language;
  final List<String> results;

  const _SearchLoaded(this.results, this.language);

  @override
  List<Object> get props => [results];
}

class _HistoryDeleted extends _SearchScreenEvent {
  final String language;
  const _HistoryDeleted(this.language);

  @override
  List<Object> get props => [];
}

abstract class _SearchScreenBlocState extends Equatable {
  const _SearchScreenBlocState();
  Widget getWidget();
}

class _LoadingSearchState extends _SearchScreenBlocState {
  final String language;

  const _LoadingSearchState(this.language);

  @override
  List<Object> get props => [];

  @override
  Widget getWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchBarWithBackButton(language),
        const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}

class _SearchedState extends _SearchScreenBlocState {
  final List<String> results;
  final String language;

  const _SearchedState(this.results, this.language);

  @override
  List<Object> get props => [results];

  @override
  Widget getWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchBarWithBackButton(language),
        GenericEntryList(
          results,
          results
              .map(
                (result) => {
                  'language': language,
                  'articleName': result,
                },
              )
              .toList(),
          onTap: (entry) {
            SharedPreferences localStorage = Get.find();
            List<String> history =
                localStorage.getStringList('searchHistory') ?? [];
            Map<String, String> entryMap = entry as Map<String, String>;
            history
                .add('${entryMap['language']!}||${entryMap['articleName']!}');
            localStorage.setStringList('searchHistory', history);

            MyRouterDelegate routerDelegate = Get.find();
            routerDelegate.popRoute();
            routerDelegate.pushPage('/article', arguments: entry);
          },
        )
      ],
    );
  }
}

class _HistoryState extends _SearchScreenBlocState {
  final String language;

  const _HistoryState(this.language);

  @override
  List<Object> get props => [];

  @override
  Widget getWidget() {
    SharedPreferences localStorage = Get.find();
    List<String> history = localStorage.getStringList('searchHistory') ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchBarWithBackButton(language),
        _HistoryHeader(language),
        GenericEntryList(
          history.reversed.map((entry) => entry.split('||')[1]).toList(),
          history.reversed.toList(),
          onTap: (entry) {
            MyRouterDelegate routerDelegate = Get.find();
            routerDelegate.popRoute();
            List<String> split = (entry as String).split('||');
            routerDelegate.pushPage('/article', arguments: {
              'language': split[0],
              'articleName': split[1],
            });
          },
        ),
      ],
    );
  }
}

class _SearchScreenBloc
    extends Bloc<_SearchScreenEvent, _SearchScreenBlocState> {
  _SearchScreenBloc(String language) : super(_HistoryState(language)) {
    on<_SearchPerformed>(onSearchPerformed);
    on<_SearchLoaded>(onSearchLoaded);
    on<_HistoryDeleted>(onHistoryDeleted);
  }

  void onSearchPerformed(
      _SearchPerformed event, Emitter<_SearchScreenBlocState> emit) {
    if (event.query == '') {
      emit(_HistoryState(event.language));
    } else {
      emit(_LoadingSearchState(event.language));
    }
  }

  void onSearchLoaded(
      _SearchLoaded event, Emitter<_SearchScreenBlocState> emit) {
    if (state is _LoadingSearchState) {
      emit(_SearchedState(event.results, event.language));
    }
  }

  void onHistoryDeleted(
      _HistoryDeleted event, Emitter<_SearchScreenBlocState> emit) {
    SharedPreferences localStorage = Get.find();
    localStorage.setStringList('searchHistory', []);
    emit(_HistoryState(event.language));
  }
}

class _SearchScreenStateful extends StatefulWidget {
  final String language;

  const _SearchScreenStateful(this.language);

  @override
  State<_SearchScreenStateful> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<_SearchScreenStateful> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_SearchScreenBloc, _SearchScreenBlocState>(
      builder: (context, _SearchScreenBlocState state) {
        return state.getWidget();
      },
    );
  }
}

class _SearchBarWithBackButton extends StatelessWidget {
  final String language;
  const _SearchBarWithBackButton(this.language)
      : super(key: const Key('_SearchBarWithBackButton'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const CustomBackButton(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SearchBar(
                onSubmitted: (String query) {
                  BlocProvider.of<_SearchScreenBloc>(context)
                      .add(_SearchPerformed(query, language));

                  if (query == '') {
                    return;
                  }

                  getSearchResults(language, query).then((results) {
                    BlocProvider.of<_SearchScreenBloc>(context)
                        .add(_SearchLoaded(results, language));
                  });
                },
              ),
            ),
          ),
          _LanguageChangeButton(language),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final String language;

  const _HistoryHeader(this.language);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
            child: Text(
              AppLocalizations.of(context)!.recentSearches,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 20, bottom: 10),
          child: CustomButton(
            Icons.delete,
            () {
              BlocProvider.of<_SearchScreenBloc>(context)
                  .add(_HistoryDeleted(language));
            },
            size: 32.0,
          ),
        )
      ],
    );
  }
}

class SearchScreen extends StatelessWidget {
  final String language;

  SearchScreen(this.language) : super(key: Key('SearchScreen:$language'));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _SearchScreenBloc(language);
      },
      child: _SearchScreenStateful(language),
    );
  }
}

class _LanguageChangeButton extends StatelessWidget {
  final String language;

  const _LanguageChangeButton(this.language);

  @override
  Widget build(BuildContext context) {
    return CustomButton(Icons.language, () {
      MyRouterDelegate routerDelegate = Get.find();
      routerDelegate.pushPage('/language', arguments: {
        'articleLanguage': Localizations.localeOf(context).languageCode,
        'articleName': AppLocalizations.of(context)!.mainPage,
        'insteadOfNavigation': (language) {
          MyRouterDelegate routerDelegate = Get.find();
          routerDelegate.popRoute(); // Current search screen
          routerDelegate.pushPage('/search', arguments: language);
        }
      });
    });
  }
}
