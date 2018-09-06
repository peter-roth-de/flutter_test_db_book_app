import 'package:flutter/material.dart';
import 'package:flutter_test_db_book_app/data/repository.dart';
import 'package:flutter_test_db_book_app/model/book.dart';
import 'package:flutter_test_db_book_app/widgets/bookCardCompact.dart';


abstract class StampCollectionPageAbstractState<T extends StatefulWidget> extends State<T> {


  List<Book> items = new List();


  @override
  void initState() {
    super.initState();
    Repository.get().getFavoriteBooks()
        .then((books) {
      setState(() {
        items = books;
      });
    });
  }


}