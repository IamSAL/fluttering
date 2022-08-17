import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class WordPairGenerator extends StatefulWidget {
  const WordPairGenerator({Key? key}) : super(key: key);

  @override
  WordPairGeneratorState createState() => WordPairGeneratorState();
}

class WordPairGeneratorState extends State<WordPairGenerator> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildRow(WordPair pair, int index) {
    final isAlreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
      title: Text("${pair.asPascalCase}"),
      trailing: Icon(
        isAlreadySaved ? Icons.favorite : Icons.favorite_border,
        color: isAlreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (isAlreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          if (item.isOdd) {
            return const Divider();
          }

          final index = item ~/ 2;
          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_randomWordPairs[index], index);
        });
  }

  void _goToSavedPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
          return ListTile(
            title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16.0)),
          );
        });

        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: tiles).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved WordPairs'),
            backgroundColor: Colors.purple[900],
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Wordpair Generator")),
          backgroundColor: Colors.purple[900],
          actions: <Widget>[
            IconButton(onPressed: _goToSavedPage, icon: Icon(Icons.list))
          ],
        ),
        body: Center(
          child: _buildList(),
        ));
  }
}
