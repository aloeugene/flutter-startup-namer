import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup name generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        });

        final List<Widget> divided = ListTile.divideTiles(
          tiles: tiles,
          context: context,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved suggestions'),
          ),
          body: ListView(
            children: divided,
          ),
        );
      },
    ));
  }

  Widget _buildRow(WordPair pair) {
    final bool isSaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (isSaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
      padding: const EdgeInsets.all(16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup name generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
