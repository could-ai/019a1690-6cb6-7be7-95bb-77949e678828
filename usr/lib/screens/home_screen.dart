import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../data/mock_profiles.dart';
import '../widgets/profile_card.dart';
import 'profile_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();

  List<Profile> profiles = mockProfiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.pink,
      ),
      body: profiles.isEmpty
          ? const Center(
              child: Text('No more profiles!'),
            )
          : CardSwiper(
              controller: controller,
              cardsCount: profiles.length,
              onSwipe: _onSwipe,
              onUndo: _onUndo,
              numberOfCardsDisplayed: 2,
              backCardOffset: const Offset(40, 40),
              padding: const EdgeInsets.all(24.0),
              cardBuilder: (
                context,
                index,
                horizontalThresholdPercentage,
                verticalThresholdPercentage,
              ) =>
                  ProfileCard(
                    profile: profiles[index],
                    onTap: () => _navigateToProfile(profiles[index]),
                  ),
            ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      context.read<AppState>().addMatch(profiles[previousIndex]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Liked ${profiles[previousIndex].name}!')),
      );
    } else if (direction == CardSwiperDirection.left) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passed')),
      );
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  void _navigateToProfile(Profile profile) {
    Navigator.pushNamed(
      context,
      '/profile',
      arguments: profile,
    );
  }
}