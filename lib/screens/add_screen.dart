import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _placeNameController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _distanceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _memoryController = TextEditingController();

  String _previewUrl = '';

  @override
  void dispose() {
    _placeNameController.dispose();
    _locationNameController.dispose();
    _distanceController.dispose();
    _imageUrlController.dispose();
    _memoryController.dispose();
    super.dispose();
  }

  void _onImageUrlChanged() {
    setState(() {
      _previewUrl = _imageUrlController.text.trim();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Will connect to API later
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Memo added successfully!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: const Text(
          'Add New Memo',
          style: TextStyle(
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _previewUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _previewUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImageError();
                          },
                        ),
                      )
                    : _buildImageEmpty(),
              ),

              const SizedBox(height: 20),

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
                    value!.isEmpty ? 'Location name is required' : null,
              ),

              CustomTextField(
                label: 'Distance from Addis Ababa',
                hint: 'e.g. 563 Km',
                icon: Icons.directions_car,
                controller: _distanceController,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Distance is required' : null,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.image, size: 16, color: Color(0xFF2E7D32)),
                      SizedBox(width: 6),
                      Text(
                        'Image URL',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _imageUrlController,
                    onChanged: (_) => _onImageUrlChanged(),
                    decoration: InputDecoration(
                      hintText: 'Paste image link here...',
                      hintStyle: TextStyle(
                          color: Colors.grey[400], fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF2E7D32), width: 2),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Image URL is required' : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              CustomTextField(
                label: 'Memory',
                hint: 'Write your memory about this place...',
                icon: Icons.note_alt,
                controller: _memoryController,
                isMultiline: true,
                validator: (value) =>
                    value!.isEmpty ? 'Memory is required' : null,
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Memory',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate,
            size: 60, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'Paste an image URL below\nto preview it here',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildImageError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'Invalid image URL',
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      ],
    );
  }
}