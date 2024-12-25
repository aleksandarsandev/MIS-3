import 'package:flutter/material.dart';
import 'package:lab2_211213/screens/favorites.dart';

import '../services/api_service.dart';
import 'global.dart';

class JokeScreen extends StatefulWidget {
  @override
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  late Map<String, dynamic> currentJoke;

  @override
  void initState() {
    super.initState();
    _fetchJoke();
  }

  void _fetchJoke() async {
    final joke = await ApiService.getRandomJoke();
    setState(() {
      currentJoke = joke;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentJoke.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Random Joke"),
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
                );
              },
            ),
          ],
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isFavorite = favoriteJokes.any(
      (j) =>
          j['setup'] == currentJoke['setup'] &&
          j['punchline'] == currentJoke['punchline'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Joke"),
        backgroundColor: Colors.green.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              // Navigate to FavoritesScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesScreen(favoriteJokes: favoriteJokes),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentJoke['setup'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                currentJoke['punchline'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      favoriteJokes.removeWhere(
                        (j) =>
                            j['setup'] == currentJoke['setup'] &&
                            j['punchline'] == currentJoke['punchline'],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Removed from favorites")),
                      );
                    } else {
                      favoriteJokes.add({
                        'setup': currentJoke['setup'],
                        'punchline': currentJoke['punchline'],
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Added to favorites")),
                      );
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchJoke,
                child: Text("Get Another Joke"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
