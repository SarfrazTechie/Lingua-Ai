
import 'package:flutter/material.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saved', style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Your saved phrases', style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.bookmark_border_rounded,
                            color: Color(0xFF00C896), size: 40),
                      ),
                      const SizedBox(height: 20),
                      const Text('No saved phrases yet', style: TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Save translations to access them quickly',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 14),
                        textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
