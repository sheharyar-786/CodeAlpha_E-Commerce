import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../product/data/models/product_model.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_event.dart';
import '../../../product/presentation/bloc/product_state.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descController = TextEditingController();
  
  String _selectedCategory = 'Electronics';
  final List<String> _categories = ['Electronics', 'Fashion', 'Accessories', 'Home'];
  String _imageUrl = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop'; // Default placeholder

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      String sellerId = 'mock_seller_1';
      String sellerName = 'AeroAudio Tech';
      if (authState is Authenticated) {
        sellerId = authState.user.uid;
        sellerName = authState.user.name;
      }

      final newProduct = ProductModel(
        id: 'prod_${const Uuid().v4()}',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        imageUrl: _imageUrl,
        category: _selectedCategory,
        sellerId: sellerId,
        sellerName: sellerName,
        rating: 5.0,
        createdAt: DateTime.now(),
      );

      context.read<ProductBloc>().add(AddProductEvent(product: newProduct));
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Enter $label',
          ),
          validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Add Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product listed successfully!'), backgroundColor: AppColors.success),
            );
            Navigator.pop(context); // Go back to dashboard
          } else if (state is ProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: AppColors.error),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Image Picker Box Simulation
              GestureDetector(
                onTap: () {
                  // Simulate image picking from gallery
                  setState(() {
                    // Cycles mock images for variety
                    if (_imageUrl.contains('photo-1542291026')) {
                      _imageUrl = 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?q=80&w=600&auto=format&fit=crop'; // shoes
                    } else {
                      _imageUrl = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop'; // red sneaker
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image loaded from gallery simulation.'), duration: Duration(seconds: 1)),
                  );
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2E2E50)),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrl),
                      fit: BoxFit.cover,
                      opacity: 0.8,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Change Image', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Inputs
              _buildTextField('Product Title', _titleController),
              Row(
                children: [
                  Expanded(child: _buildTextField('Price (\$)', _priceController, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Stock', _stockController, keyboardType: TextInputType.number)),
                ],
              ),

              // Category dropdown
              const Text('Category', style: TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: AppColors.darkSurface,
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              _buildTextField('Description', _descController, maxLines: 4),
              const SizedBox(height: 24),

              // Submit Button
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  final isLoading = state is ProductLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Publish Product'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
