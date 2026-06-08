import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../data/models/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final updatedItems = List<CartItemModel>.from(state.items);
    final existingIndex = updatedItems.indexWhere((item) => item.product.id == event.product.id);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      updatedItems.add(CartItemModel(product: event.product, quantity: event.quantity));
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedItems = List<CartItemModel>.from(state.items)
      ..removeWhere((item) => item.product.id == event.productId);
    emit(state.copyWith(items: updatedItems));
  }

  void _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCart(productId: event.productId));
      return;
    }
    
    final updatedItems = List<CartItemModel>.from(state.items);
    final index = updatedItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      updatedItems[index] = updatedItems[index].copyWith(quantity: event.quantity);
      emit(state.copyWith(items: updatedItems));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
