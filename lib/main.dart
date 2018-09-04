import 'dart:async';

/*******
 * https://github.com/Norbert515/BookSearch/blob/v1/lib/main.dart
 *
 * Thanks to Norbert Kozsir the one who published the flutter demo which inspired me.
 * https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b
 *
 */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';


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
      home: new MyHomePage(title: 'Book Search'),
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

  void _exp_textChanged(String text) async {
    print("!!!! _textChanged called !!!");
    // https://jsonplaceholder.typicode.com/posts
    // https//www.googleapis.com/books/v1/volumes?q=$text
    // https://books.google.com?q=$text
    // https://www.google.de/search?q=$text
    final response = await http.get('https://books.google.com?q=$text');
    // compute function to run parsePosts in a separate isolate
    print(response.body);
  }

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

  void _callWeb(String text) {
     //"https//www.googleapis.com/books/v1/volumes?q=$text"
    // final response = http.get("https://books.google.com?q=$text")
    http.get("https://www.googleapis.com/books/v1/volumes?q=$text")
        .then((response) => print(response.body))
        //.then((response) => response.body)
        //.then(json.decode)
        ;
        /*
      .then((response) => response.body)
      .then(json.decode)
      .then((map) => map["items"])
      .then((list) {list.forEach(_addBook);})
      .catchError(_onError)
      .then((e){setState(() {_isLoading = false;});});
      */
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
      _items.add(new Book(book["volumeInfo"]["title"], book["volumeInfo"]["imageLinks"]["smallThumbnail"]));
    });
  }

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 600)).listen(_textChanged);
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
                      return new Card(
                        child: new Padding(
                            padding: new EdgeInsets.all(8.0),
                            child: new Row(
                              children: <Widget>[
                                _items[index].url != null? new Image.network(_items[index].url): new Container(),
                                new Flexible(
                                  child: new Text(_items[index].title, maxLines: 10),
                                ),
                              ],
                            )
                        )
                      );
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


class Book {
  String title, url;
  Book(String title, String url) {
    this.title = title;
    this.url = url;
  }
}