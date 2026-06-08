import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductOperationSuccess extends ProductState {}

class ProductFailure extends ProductState {
  final String errorMessage;

  const ProductFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
