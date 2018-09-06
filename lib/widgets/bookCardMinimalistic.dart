import 'package:flutter/material.dart';
import 'package:flutter_test_db_book_app/model/book.dart';


class BookCardMinimalistic extends StatelessWidget {



  BookCardMinimalistic(this.book);

  final Book book;


  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.network(book.url),
        ],
      ),
    );
  }

}