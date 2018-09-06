import 'package:flutter/material.dart';
import 'package:flutter_test_db_book_app/data/repository.dart';
import 'package:flutter_test_db_book_app/model/book.dart';
import 'package:flutter_test_db_book_app/pages/abstract/stampCollectionPageAbstract.dart';
import 'package:flutter_test_db_book_app/widgets/bookCardCompact.dart';


class StampCollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StampCollectionPageState();
}

class _StampCollectionPageState extends StampCollectionPageAbstractState<StampCollectionPage> {
  @override
  Widget build(BuildContext context) {

    Matrix4 transform = new Matrix4.skewX(10.0);
    transform.translate(-100.0);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stamp Collection"),
      ),
      body: new ListView.builder(itemBuilder: (BuildContext context, int index){
        return new BookCardCompact(items[index], onClick: (){},);
      },
        itemCount: items.length,
      ),
    );
  }
}