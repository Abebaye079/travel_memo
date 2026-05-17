import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../providers/memo_provider.dart';
import '../models/memo.dart';

class DetailsScreen extends StatefulWidget {
  final Memo memo;

  const DetailsScreen({
    super.key,
    required this.memo,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isEditing = false;

  late TextEditingController _placeNameController;
  late TextEditingController _locationNameController;
  late TextEditingController _distanceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _memoryController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _placeNameController =
        TextEditingController(text: widget.memo.placeName);
    _locationNameController =
      TextEditingController(text: widget.memo.locationName);
    _distanceController =
      TextEditingController(text: widget.memo.distance);
    _imageUrlController =
      TextEditingController(text: widget.memo.imageUrl);
    _memoryController =
      TextEditingController(text: widget.memo.memory);
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _locationNameController.dispose();
    _distanceController.dispose();
    _imageUrlController.dispose();
    _memoryController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveEdit() async {
    if (_formKey.currentState!.validate()) {
      final updatedMemo = Memo(
        id: widget.memo.id,
        placeName: _placeNameController.text.trim(),
        locationName: _locationNameController.text.trim(),
        distance: _distanceController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        memory: _memoryController.text.trim(),
      );

      final success =
          await context.read<MemoProvider>().updateMemo(updatedMemo);

      if (success && mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Memo updated successfully!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update memo. Try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Memo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this memory?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // close dialog
              final success = await context
                  .read<MemoProvider>()
                  .deleteMemo(widget.memo.id);
              if (success && mounted) {
                Navigator.pop(context, 'deleted');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Text(
          _isEditing ? 'Edit Memo' : 'Memo Details',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _imageUrlController.text.isNotEmpty
                    ? Image.network(
                        _imageUrlController.text,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  size: 60, color: Colors.grey),
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 250,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 60, color: Colors.grey),
                        ),
                      ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    _placeNameController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isEditing) ...[
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.location_on,
                            _locationNameController.text,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoChip(
                            Icons.directions_car,
                            _distanceController.text,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'My Memory',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          _memoryController.text.isNotEmpty
                              ? _memoryController.text
                              : 'No memory written yet.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _toggleEdit,
                              icon: const Icon(Icons.edit,
                                  color: Colors.white, size: 18),
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _confirmDelete,
                              icon: const Icon(Icons.delete,
                                  color: Colors.white, size: 18),
                              label: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (_isEditing) ...[
                      CustomTextField(
                        label: 'Place Name',
                        hint: 'e.g. Tana Lake',
                        icon: Icons.place,
                        controller: _placeNameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Place name is required' : null,
                      ),
                      CustomTextField(
                        label: 'Location Name',
                        hint: 'e.g. Bahir Dar',
                        icon: Icons.location_city,
                        controller: _locationNameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Location is required' : null,
                      ),
                      CustomTextField(
                        label: 'Distance from Addis Ababa',
                        hint: 'e.g. 563 Km',
                        icon: Icons.directions_car,
                        controller: _distanceController,
                        validator: (value) =>
                            value!.isEmpty ? 'Distance is required' : null,
                      ),
                      CustomTextField(
                        label: 'Image URL',
                        hint: 'Paste image link here...',
                        icon: Icons.image,
                        controller: _imageUrlController,
                        validator: (value) =>
                            value!.isEmpty ? 'Image URL is required' : null,
                      ),
                      CustomTextField(
                        label: 'Memory',
                        hint: 'Write your memory here...',
                        icon: Icons.note_alt,
                        controller: _memoryController,
                        isMultiline: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Memory is required' : null,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}