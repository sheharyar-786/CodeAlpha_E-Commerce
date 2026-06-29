import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/product_model.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class ProductRepository {
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  ProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore;

  // Premium Mock Data
  static final List<ProductModel> _mockProducts = [
    ProductModel(
      id: 'prod_1',
      title: 'AeroSound Pro Headphones',
      description: 'Experience studio-quality audio with advanced active noise cancellation, 40-hour battery life, and ultra-comfortable memory foam earcups.',
      price: 299.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600&auto=format&fit=crop',
      category: 'Electronics',
      sellerId: 'mock_seller_1',
      sellerName: 'AeroAudio Tech',
      rating: 4.8,
      stock: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ProductModel(
      id: 'prod_2',
      title: 'Urban Craft Leather Backpack',
      description: 'Handcrafted from full-grain vegetable-tanned leather. Includes a padded 16-inch laptop compartment, secret passport pocket, and weather-resistant zippers.',
      price: 189.50,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=600&auto=format&fit=crop',
      category: 'Fashion',
      sellerId: 'mock_seller_2',
      sellerName: 'Heritage Goods',
      rating: 4.7,
      stock: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ProductModel(
      id: 'prod_3',
      title: 'KeyChron K6 Mechanical Keyboard',
      description: 'Hot-swappable tactile blue switches, double-shot keycaps, elegant aluminum frame, and vibrant customizable RGB backlighting. Bluetooth 5.1 and wired mode.',
      price: 119.99,
      imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?q=80&w=600&auto=format&fit=crop',
      category: 'Electronics',
      sellerId: 'mock_seller_1',
      sellerName: 'AeroAudio Tech',
      rating: 4.9,
      stock: 20,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ProductModel(
      id: 'prod_4',
      title: 'SolChron Smart Chronograph',
      description: 'Hybrid smartwatch combining mechanical hands with an OLED fitness dashboard. Heart rate monitoring, GPS tracking, and a gorgeous sapphire crystal lens.',
      price: 349.00,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600&auto=format&fit=crop',
      category: 'Accessories',
      sellerId: 'mock_seller_3',
      sellerName: 'SolTime Labs',
      rating: 4.6,
      stock: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ProductModel(
      id: 'prod_5',
      title: 'Barista Classic Espresso Machine',
      description: 'Professional 15-bar Italian pump espresso maker. Built-in steam wand for velvety lattes, adjustable temperature control, and a sleek brushed steel body.',
      price: 499.00,
      imageUrl: 'https://images.unsplash.com/photo-1517256064527-09c53b2d0c6b?q=80&w=600&auto=format&fit=crop',
      category: 'Home & Kitchen',
      sellerId: 'mock_seller_4',
      sellerName: 'BrewMaster Corp',
      rating: 4.5,
      stock: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  Future<void> seedProductsIfEmpty() async {
    if (AuthRepository.useMock) return;
    try {
      final snapshot = await firestore.collection('products').limit(1).get();
      if (snapshot.docs.isEmpty) {
        for (var product in _mockProducts) {
          await firestore.collection('products').doc(product.id).set(product.toMap());
        }
        debugPrint('Firestore seeded with premium default products.');
      }
    } catch (e) {
      debugPrint('Error seeding Firestore products: $e');
    }
  }

  Future<List<ProductModel>> fetchProducts({String? category}) async {
    if (AuthRepository.useMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (category == null || category == 'All') {
        return _mockProducts;
      }
      return _mockProducts.where((p) => p.category == category).toList();
    }

    try {
      Query query = firestore.collection('products');
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      
      final QuerySnapshot snapshot = await query.orderBy('createdAt', descending: true).get();
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e.toString().contains('no-app') || e.toString().contains('core/')) {
        AuthRepository.useMock = true;
        return fetchProducts(category: category);
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String queryStr) async {
    if (AuthRepository.useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (queryStr.isEmpty) return _mockProducts;
      return _mockProducts
          .where((p) => p.title.toLowerCase().contains(queryStr.toLowerCase()) || 
                        p.description.toLowerCase().contains(queryStr.toLowerCase()))
          .toList();
    }

    try {
      // Basic text search. For premium production, one would use Algolia or client-side filter for moderate size
      final QuerySnapshot snapshot = await firestore.collection('products').get();
      final all = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      if (queryStr.isEmpty) return all;
      return all
          .where((p) => p.title.toLowerCase().contains(queryStr.toLowerCase()) ||
                        p.description.toLowerCase().contains(queryStr.toLowerCase()))
          .toList();
    } catch (e) {
      if (e.toString().contains('no-app') || e.toString().contains('core/')) {
        AuthRepository.useMock = true;
        return searchProducts(queryStr);
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchSellerProducts(String sellerId) async {
    if (AuthRepository.useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockProducts.where((p) => p.sellerId == sellerId).toList();
    }

    try {
      final QuerySnapshot snapshot = await firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e.toString().contains('no-app') || e.toString().contains('core/')) {
        AuthRepository.useMock = true;
        return fetchSellerProducts(sellerId);
      }
      rethrow;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    if (AuthRepository.useMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      _mockProducts.insert(0, product);
      return;
    }

    try {
      await firestore.collection('products').doc(product.id).set(product.toMap());
    } catch (e) {
      if (e.toString().contains('no-app') || e.toString().contains('core/')) {
        AuthRepository.useMock = true;
        await addProduct(product);
        return;
      }
      rethrow;
    }
  }
}
