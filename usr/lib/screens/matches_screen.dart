import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = context.watch<AppState>().matches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        backgroundColor: Colors.pink,
      ),
      body: matches.isEmpty
          ? const Center(
              child: Text('No matches yet. Keep swiping!'),
            )
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final profile = matches[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profile.photoUrl),
                  ),
                  title: Text(profile.name),
                  subtitle: Text('${profile.age} years old'),
                  onTap: () => _navigateToProfile(context, profile),
                );
              },
            ),
    );
  }

  void _navigateToProfile(BuildContext context, Profile profile) {
    Navigator.pushNamed(
      context,
      '/profile',
      arguments: profile,
    );
  }
}