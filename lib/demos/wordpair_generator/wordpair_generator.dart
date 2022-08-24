import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordPairGenerator extends StatefulWidget {
  const WordPairGenerator({Key? key}) : super(key: key);

  @override
  WordPairGeneratorState createState() => WordPairGeneratorState();
}

class WordPairGeneratorState extends State<WordPairGenerator> {
  final _randomWordPairs = <String>[];
  Set _savedWordPairs = Set<String>();

  void _loadSavedList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedListRaw = prefs.getString('savedWordPairs');

    setState(() {
      if (savedListRaw != null) {
        _savedWordPairs = json.decode(savedListRaw).toSet();
      } else {
        _savedWordPairs = Set<String>();
      }
    });
  }

  void _saveList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'savedWordPairs', json.encode(_savedWordPairs.toList()));
  }

  @override
  void initState() {
    super.initState();
    _loadSavedList();
  }

  @override
  void dispose() async {
    super.dispose();
    _saveList();
  }

  Widget _buildRow(String pair, int index) {
    final isAlreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
      title: Text("${pair}"),
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
            _randomWordPairs.addAll(generateWordPairs()
                .take(10)
                .map((e) => e.asPascalCase)
                .toSet());
          }
          return _buildRow(_randomWordPairs[index], index);
        });
  }

  void _goToSavedPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        void rebuildParent() {
          setState(() {});
        }

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          Iterable<ListTile> tiles = _savedWordPairs.map((dynamic pair) {
            return ListTile(
              title: Text(pair, style: TextStyle(fontSize: 16.0)),
              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      _savedWordPairs.remove(pair);
                      rebuildParent();
                    });
                  },
                  child: Icon(Icons.delete)),
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
        });
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
