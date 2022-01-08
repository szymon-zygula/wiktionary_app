import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'router_delegate.dart';

class SearchBar extends StatelessWidget {
  final Function(String)? onSubmitted;

  const SearchBar({this.onSubmitted}) : super(key: const Key('SearchBar'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(224, 224, 224, 1.0),
        borderRadius: BorderRadius.circular(1000.0),
      ),
      child: TextField(
        autofocus: true,
        maxLines: 1,
        onSubmitted: onSubmitted,
        cursorColor: const Color.fromRGBO(64, 64, 64, 1.0),
        decoration: const InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class DummySearchBar extends StatelessWidget {
  final Function()? onTap;
  const DummySearchBar({this.onTap}) : super(key: const Key('SearchBar'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(224, 224, 224, 1.0),
        borderRadius: BorderRadius.circular(1000.0),
      ),
      child: TextField(
        maxLines: 1,
        cursorColor: const Color.fromRGBO(64, 64, 64, 1.0),
        readOnly: true,
        onTap: () {
          if (onTap != null) {
            onTap!();
          }

          MyRouterDelegate routerDelegate = Get.find();
          routerDelegate.pushPage('/search', arguments: 'en');
        },
        decoration: const InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
