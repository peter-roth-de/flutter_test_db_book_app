/*******
 * https://github.com/Norbert515/BookSearch/blob/v1/lib/main.dart
 *
 * Thanks to Norbert Kozsir the one who published the flutter demo which inspired me.
 * https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter_test_db_book_app/pages/universal/collectionPage.dart';
import 'package:flutter_test_db_book_app/pages/formal/stampCollectionPageFormal.dart';
import 'package:flutter_test_db_book_app/pages/homePage.dart';
import 'package:flutter_test_db_book_app/pages/material/searchBookPageMaterial.dart';
import 'package:flutter_test_db_book_app/pages/formal/searchBookPageFormal.dart';
import 'package:flutter_test_db_book_app/pages/material/stampCollectionPageMaterial.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_test_db_book_app/redux/appState.dart';
import 'package:flutter_test_db_book_app/redux/reducers.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  final Store<AppState> store = new Store(readBookReducer, initialState: AppState.initState());
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store:store,
      child: new MaterialApp(
        title: 'Book search',
        theme: new ThemeData(
          primaryColor: new Color(0xFFaaaaaa),//new Color(0xFF0F2533),
        ),
        routes: {
          '/': (BuildContext context) => new HomePage(),
          '/search_material': (BuildContext context) => new SearchBookPage(),
          '/search_formal': (BuildContext context) => new SearchBookPageNew(),
          '/collection': (BuildContext context) => new CollectionPage(),
          '/stamp_collection_material': (BuildContext context) => new StampCollectionPage(),
          '/stamp_collection_formal': (BuildContext context) => new StampCollectionFormalPage(),
        },
      ),
    );
  }


}