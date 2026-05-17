import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/memo_provider.dart';
import '../widgets/destination_card.dart';
import 'add_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MemoProvider>().clearError();
      context.read<MemoProvider>().fetchMemos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
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
                const Icon(Icons.place,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Places You Traveled  •  ${provider.memos.length} places',
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
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E7D32),
                    ),
                  )
                : provider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wifi_off,
                                size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              provider.error!,
                              style: TextStyle(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<MemoProvider>().fetchMemos(),
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              label: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      )
                    : provider.memos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.travel_explore,
                                    size: 60, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'No memories yet.\nTap + to add your first!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.memos.length,
                            itemBuilder: (context, index) {
                              final memo = provider.memos[index];
                              return DestinationCard(
                                placeName: memo.placeName,
                                locationName: memo.locationName,
                                distance: memo.distance,
                                thumbnailUrl: memo.imageUrl,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsScreen(memo: memo),
                                    ),
                                  );
                                  if (result == 'deleted' && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Memo deleted successfully!'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddScreen()),
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