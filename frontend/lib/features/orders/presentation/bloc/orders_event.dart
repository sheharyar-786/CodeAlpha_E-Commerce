import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  final String buyerId;

  const LoadOrders({required this.buyerId});

  @override
  List<Object?> get props => [buyerId];
}

class CreateOrderEvent extends OrdersEvent {
  final OrderModel order;

  const CreateOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class UpdateStatusEvent extends OrdersEvent {
  final String orderId;
  final OrderStatus status;

  const UpdateStatusEvent({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class LoadSellerOrdersEvent extends OrdersEvent {
  final String sellerId;

  const LoadSellerOrdersEvent({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}
