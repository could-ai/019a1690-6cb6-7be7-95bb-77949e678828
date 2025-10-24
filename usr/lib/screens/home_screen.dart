import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../data/mock_profiles.dart';
import '../widgets/profile_card.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();

  List<Profile> profiles = mockProfiles;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: profiles.isEmpty
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    backgroundColor: Colors.amber,
                    child: const Icon(Icons.undo),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    backgroundColor: Colors.white,
                    elevation: 4,
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    backgroundColor: Colors.white,
                    elevation: 4,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        SnackBar(
          content: Text('Liked ${profiles[previousIndex].name}!'),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      context.read<AppState>().removeLastMatch();
    }
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
