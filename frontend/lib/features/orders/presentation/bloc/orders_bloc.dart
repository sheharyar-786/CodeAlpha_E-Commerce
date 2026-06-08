import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/order_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;

  OrdersBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<LoadSellerOrdersEvent>(_onLoadSellerOrders);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final orders = await _orderRepository.fetchBuyerOrders(event.buyerId);
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      await _orderRepository.createOrder(event.order);
      emit(OrderOperationSuccess());
    } catch (e) {
      emit(OrdersFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateStatus(UpdateStatusEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      await _orderRepository.updateOrderStatus(event.orderId, event.status);
      emit(OrderOperationSuccess());
    } catch (e) {
      emit(OrdersFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadSellerOrders(LoadSellerOrdersEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final orders = await _orderRepository.fetchSellerOrders(event.sellerId);
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersFailure(errorMessage: e.toString()));
    }
  }
}
