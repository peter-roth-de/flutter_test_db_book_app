import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test_db_book_app/data/repository.dart';
import 'package:flutter_test_db_book_app/model/book.dart';

class AppState {
  AppState({
    this.readBooks
  });

  final List<Book> readBooks;

  static AppState initState() {
    return new AppState(readBooks: []);
  }
}