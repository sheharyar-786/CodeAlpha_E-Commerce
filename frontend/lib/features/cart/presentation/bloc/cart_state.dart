import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get shippingFee => items.isEmpty ? 0.0 : 15.0; // Flat fee
  double get tax => subtotal * 0.08; // 8% sales tax
  double get total => subtotal + shippingFee + tax;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}
