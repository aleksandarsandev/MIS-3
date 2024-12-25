import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'favorites.dart';
import 'global.dart';

class ListScreen extends StatefulWidget {
  final String jokeType;

  ListScreen({required this.jokeType});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Map<String, dynamic>>> _jokesFuture;

  @override
  void initState() {
    super.initState();
    _jokesFuture = ApiService.getJokesByType(widget.jokeType);
  }

  void _toggleFavorite(Map<String, String> joke) {
    setState(() {
      final isFavorite = favoriteJokes.any((j) =>
          j['setup'] == joke['setup'] && j['punchline'] == joke['punchline']);
      if (isFavorite) {
        favoriteJokes.removeWhere((j) =>
            j['setup'] == joke['setup'] && j['punchline'] == joke['punchline']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Removed from favorites")),
        );
      } else {
        favoriteJokes.add(joke);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added to favorites")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.jokeType} Jokes"),
        backgroundColor: Colors.green.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesScreen(favoriteJokes: favoriteJokes),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.blue.shade50,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jokesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading jokes"));
          } else {
            final jokes = snapshot.data ?? [];

            if (jokes.isEmpty) {
              return Center(
                  child: Text("No jokes available for ${widget.jokeType}"));
            }

            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                final isFavorite = favoriteJokes.any((j) =>
                    j['setup'] == joke['setup'] &&
                    j['punchline'] == joke['punchline']);
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isFavorite ? Colors.red : Colors.grey.shade300,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      joke['setup'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(joke['punchline']),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _toggleFavorite({
                          'setup': joke['setup'],
                          'punchline': joke['punchline']
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
