import 'package:equatable/equatable.dart';

enum OrderStatus { ordered, processing, shipped, delivered }

class OrderItemModel extends Equatable {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  @override
  List<Object?> get props => [productId, title, price, quantity, imageUrl];
}

class OrderModel extends Equatable {
  final String id;
  final String buyerId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final OrderStatus status;
  final String shippingAddress;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
  });

  OrderModel copyWith({
    String? id,
    String? buyerId,
    List<OrderItemModel>? items,
    double? totalAmount,
    OrderStatus? status,
    String? shippingAddress,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerId': buyerId,
      'items': items.map((x) => x.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      buyerId: map['buyerId'] ?? '',
      items: (map['items'] as List?)
              ?.map((x) => OrderItemModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(map['status']),
      shippingAddress: map['shippingAddress'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  static OrderStatus _parseStatus(String? statusStr) {
    switch (statusStr) {
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'ordered':
      default:
        return OrderStatus.ordered;
    }
  }

  @override
  List<Object?> get props => [
        id,
        buyerId,
        items,
        totalAmount,
        status,
        shippingAddress,
        createdAt,
      ];
}
