import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderOperationSuccess extends OrdersState {}

class OrdersFailure extends OrdersState {
  final String errorMessage;

  const OrdersFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
