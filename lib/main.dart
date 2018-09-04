/*******
 * https://github.com/Norbert515/BookSearch/blob/v1/lib/main.dart
 *
 * Thanks to Norbert Kozsir the one who published the flutter demo which inspired me.
 * https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b
 *
 */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test_db_book_app/model/book.dart';
import 'package:flutter_test_db_book_app/bookNotesPage.dart';
import 'package:flutter_test_db_book_app/database.dart';
import 'package:flutter_test_db_book_app/utils/utils.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book Search',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.green,
      ),
      routes: {
       '/': (BuildContext context) => new MyHomePage(title: 'Book Search'),
    }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> _items = new List();
  final subject = new PublishSubject<String>();
  bool _isLoading = false;

  void _textChanged(String text) {
    if(text.isEmpty) {
      setState((){_isLoading = false; });
      _clearList();
      return;
    }

    setState(() {_isLoading = true;});
    _clearList();
    //"https//www.googleapis.com/books/v1/volumes?q=$text"
    http.get("https://www.googleapis.com/books/v1/volumes?q=$text")
      .then((response) => response.body)
      .then(json.decode)
      .then((map) => map["items"])
      .then((list) {list.forEach(_addBook);})
      .catchError(_onError)
      .then((e){setState(() {_isLoading = false;});});
  }

  void _onError(dynamic d) {
    setState(() {
      _isLoading = false;
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  void _addBook(dynamic book) {
    setState(() {
      _items.add(new Book(
          title: book["volumeInfo"]["title"],
          url: book["volumeInfo"]["imageLinks"]["smallThumbnail"],
          id: book["id"]
      ));
    });
  }

  @override
  void dispose() {
    subject.close();
    BookDatabase.get().close();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 600)).listen(_textChanged);
    BookDatabase.get().init();
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new GestureDetector(
        onTap: () {
          this._dismissKeyboard(context);
        },
        child:  new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                hintText: "Choose a book",
              ),
              onChanged: (string) => (subject.add(string)),
            ),
            _isLoading? new CircularProgressIndicator(): new Container(),
                new Expanded(
                child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index){
                      return new BookCard(_items[index]);
                    },
                )
            )
          ],
        ),
      )
    ),
    );
  }
}

class BookCard extends StatefulWidget {
  BookCard(this.book);
  final Book book;

  @override
  State<StatefulWidget> createState() => new BookCardState();
}

class BookCardState extends State<BookCard> {
  Book bookState;

  @override
  void initState() {
    super.initState();
    bookState = widget.book;
    BookDatabase.get().getBook(widget.book.id)
      .then((book) {
        if(book == null) return;
        setState(() {
          bookState = book;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            new FadeRoute(
              builder: (BuildContext context) => new BookNotesPage(bookState),
              settings: new RouteSettings(
                  name: '/notes', isInitialRoute: false),
            ));
      },
      child: new Card(
          child: new Container(
            height: 200.0,
            child: new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    bookState.url != null ?
                    new Hero(
                      child: new Image.network(bookState.url),
                      tag: bookState.id,
                    ) :
                    new Container(),
                    new Expanded(
                      child: new Stack(
                        children: <Widget>[
                          new Align(
                              child: new Padding(
                                child: new Text(bookState.title, maxLines: 10),
                                padding: new EdgeInsets.all(8.0),
                              ),
                              alignment: Alignment.center,
                          ),
                          new Align(
                            child: new IconButton(
                              icon: bookState.starred
                                  ? new Icon(Icons.star)
                                  : new Icon(Icons.star_border),
                              color: Colors.black,
                              onPressed: () {
                                setState(() {
                                  bookState.starred = !bookState.starred;
                                });
                                BookDatabase.get().updateBook(bookState);
                              },
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          )
      ),
    );
  }
}
