import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, String>> favoriteJokes;

  FavoritesScreen({required this.favoriteJokes});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Jokes"),
        backgroundColor: Colors.green.shade50,
      ),
      backgroundColor: Colors.blue.shade50,
      body: widget.favoriteJokes.isEmpty
          ? Center(
              child: Text(
                "No favorite jokes yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.favoriteJokes.length,
              itemBuilder: (context, index) {
                final joke = widget.favoriteJokes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: ListTile(
                    title: Text(
                      joke['setup'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(joke['punchline'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.favoriteJokes.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Removed from favorites")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
