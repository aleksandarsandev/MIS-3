import 'package:flutter/material.dart';
import 'package:lab2_211213/services/notification_service.dart';

import '../services/api_service.dart';
import '../widgets/joke_card.dart';
import 'favorites.dart';
import 'global.dart';
import 'joke.dart';
import 'list.dart';

bool notificationsEnabled = false;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    notificationsEnabled;
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Enable notification permissions to recieve daily joke notification'),
          ),
        );
        return;
      }
    }

    setState(() {
      notificationsEnabled = value;
    });

    if (value) {
      await _notificationService.scheduleJokeNotification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications enabled')),
      );
    } else {
      await _notificationService.cancelNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joke Types"),
        backgroundColor: Colors.green.shade50,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_objects_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JokeScreen()),
                    );
                  },
                ),
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
                IconButton(
                  icon: Icon(
                    notificationsEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: notificationsEnabled ? Colors.yellow : null,
                  ),
                  onPressed: () {
                    _toggleNotifications(!notificationsEnabled);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: FutureBuilder<List<String>>(
          future: ApiService.getJokeTypes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading joke types"));
            } else {
              final jokeTypes = snapshot.data ?? [];

              if (jokeTypes.isEmpty) {
                return Center(child: Text("No joke types available"));
              }

              return ListView.builder(
                itemCount: jokeTypes.length,
                itemBuilder: (context, index) {
                  return JokeCard(
                    title: jokeTypes[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListScreen(jokeType: jokeTypes[index]),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
