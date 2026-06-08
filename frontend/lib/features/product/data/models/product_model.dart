import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String sellerId;
  final String sellerName;
  final double rating;
  final int stock;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    this.rating = 5.0,
    this.stock = 10,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? sellerId,
    String? sellerName,
    double? rating,
    int? stock,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'rating': rating,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? 'Unknown Seller',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        imageUrl,
        category,
        sellerId,
        sellerName,
        rating,
        stock,
        createdAt,
      ];
}
