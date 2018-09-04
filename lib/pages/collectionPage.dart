import 'package:flutter/material.dart';
import 'package:flutter_test_db_book_app/data/repository.dart';
import 'package:flutter_test_db_book_app/model/book.dart';
import 'package:flutter_test_db_book_app/pages/bookNotesPage.dart';
import 'package:flutter_test_db_book_app/utils/utils.dart';
import 'package:flutter_test_db_book_app/widgets/bookCard.dart';


class CollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Book> _items = new List();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Repository.get().getFavoriteBooks()
        .then((books) {
      setState(() {
        _items = books;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Collection"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Stack(
          children: <Widget>[
            _isLoading? new CircularProgressIndicator(): new Container(),
            new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return new BookCard(
                  book: _items[index],
                  onCardClick: (){
                    Navigator.of(context).push(
                        new FadeRoute(
                          builder: (BuildContext context) => new BookNotesPage(_items[index]),
                          settings: new RouteSettings(name: '/notes', isInitialRoute: false),
                        ));
                  },
                  onStarClick: (){
                    setState(() {
                      _items[index].starred = !_items[index].starred;
                    });
                    Repository.get().updateBook(_items[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),

    );
  }

}