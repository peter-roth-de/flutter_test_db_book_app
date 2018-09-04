/*******
 * https://github.com/Norbert515/BookSearch/blob/v1/lib/main.dart
 *
 * Thanks to Norbert Kozsir the one who published the flutter demo which inspired me.
 * https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter_test_db_book_app/pages/collectionPage.dart';
import 'package:flutter_test_db_book_app/pages/homePage.dart';
import 'package:flutter_test_db_book_app/pages/searchBookPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (BuildContext context) => new HomePage(),
        '/search': (BuildContext context) => new SearchBookPage(),
        '/collection': (BuildContext context) => new CollectionPage(),
      },
    );
  }


}
