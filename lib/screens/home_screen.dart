import 'package:flutter/material.dart';
import '../widgets/destination_card.dart';
import 'add_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> dummyMemos = const [
    {
      'placeName': 'Jegol Wall',
      'locationName': 'Harar',
      'distance': '526 Km',
      'thumbnailUrl': 'https://picsum.photos/seed/jegol/300/200',
    },
    {
      'placeName': 'Tana Lake',
      'locationName': 'Bahir Dar',
      'distance': '563 Km',
      'thumbnailUrl': 'https://picsum.photos/seed/tana/300/200',
    },
    {
      'placeName': 'Dalol',
      'locationName': 'Afar',
      'distance': '780 Km',
      'thumbnailUrl': 'https://picsum.photos/seed/dalol/300/200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 1,
        title: const Text(
          'TRAVEL MEMO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.place, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Places You Traveled  •  ${dummyMemos.length} places',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyMemos.length,
              itemBuilder: (context, index) {
                final memo = dummyMemos[index];
                return DestinationCard(
                  placeName: memo['placeName']!,
                  locationName: memo['locationName']!,
                  distance: memo['distance']!,
                  thumbnailUrl: memo['thumbnailUrl']!,
                  onTap: () {
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddScreen()),
    );
        },
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Memo',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}