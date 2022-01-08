import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router_delegate.dart';
import 'search_bar.dart';
import 'generic_entry_list.dart';
import 'custom_buttons.dart';
import 'debug.dart';
import 'wiktionary_api.dart';

abstract class _SearchScreenEvent extends Equatable {
  const _SearchScreenEvent();
}

class _SearchPerformed extends _SearchScreenEvent {
  final String query;

  const _SearchPerformed(this.query);

  @override
  List<Object> get props => [query];
}

class _SearchLoaded extends _SearchScreenEvent {
  final List<String> results;

  const _SearchLoaded(this.results);

  @override
  List<Object> get props => [results];
}

class _HistoryDeleted extends _SearchScreenEvent {
  const _HistoryDeleted();

  @override
  List<Object> get props => [];
}

abstract class _SearchScreenBlocState extends Equatable {
  const _SearchScreenBlocState();
  Widget getWidget();
}

class _LoadingSearchState extends _SearchScreenBlocState {
  const _LoadingSearchState();

  @override
  List<Object> get props => [];

  @override
  Widget getWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SearchBarWithBackButton(),
        Expanded(
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

  const _SearchedState(this.results);

  @override
  List<Object> get props => [results];

  @override
  Widget getWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SearchBarWithBackButton(),
        GenericEntryList(
          results,
          results
              .map(
                (result) => {
                  "language": "en",
                  "articleName": result,
                },
              )
              .toList(),
          onTap: (entry) {
            SharedPreferences localStorage = Get.find();
            List<String> history =
                localStorage.getStringList('searchHistory') ?? [];
            Map<String, String> entryMap = entry as Map<String, String>;
            history
                .add("${entryMap['language']!}||${entryMap['articleName']!}");
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
  const _HistoryState();

  @override
  List<Object> get props => [];

  @override
  Widget getWidget() {
    SharedPreferences localStorage = Get.find();
    List<String> history = localStorage.getStringList('searchHistory') ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SearchBarWithBackButton(),
        _HistoryHeader(),
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
  _SearchScreenBloc() : super(const _HistoryState()) {
    on<_SearchPerformed>(onSearchPerformed);
    on<_SearchLoaded>(onSearchLoaded);
    on<_HistoryDeleted>(onHistoryDeleted);
  }

  void onSearchPerformed(
      _SearchPerformed event, Emitter<_SearchScreenBlocState> emit) {
    if (event.query == "") {
      emit(const _HistoryState());
    } else {
      emit(const _LoadingSearchState());
    }
  }

  void onSearchLoaded(
      _SearchLoaded event, Emitter<_SearchScreenBlocState> emit) {
    if (state is _LoadingSearchState) {
      emit(_SearchedState(event.results));
    }
  }

  void onHistoryDeleted(
      _HistoryDeleted event, Emitter<_SearchScreenBlocState> emit) {
    SharedPreferences localStorage = Get.find();
    localStorage.setStringList('searchHistory', []);
    emit(const _HistoryState());
  }
}

class _SearchScreenStateful extends StatefulWidget {
  const _SearchScreenStateful();

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
  const _SearchBarWithBackButton()
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
                      .add(_SearchPerformed(query));

                  if (query == "") {
                    return;
                  }

                  getSearchResults('en', query).then((results) {
                    BlocProvider.of<_SearchScreenBloc>(context)
                        .add(_SearchLoaded(results));
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
            child: const Text(
              'Recent searches:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 20, bottom: 10),
          child: CustomButton(
            Icons.delete,
            () {
              BlocProvider.of<_SearchScreenBloc>(context)
                  .add(const _HistoryDeleted());
            },
            size: 32.0,
          ),
        )
      ],
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen() : super(key: const Key('SearchScreen'));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _SearchScreenBloc();
      },
      child: const _SearchScreenStateful(),
    );
  }
}
