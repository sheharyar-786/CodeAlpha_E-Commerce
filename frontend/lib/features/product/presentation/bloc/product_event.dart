import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String? category;

  const LoadProducts({this.category});

  @override
  List<Object?> get props => [category];
}

class SearchProductsQuery extends ProductEvent {
  final String query;

  const SearchProductsQuery({required this.query});

  @override
  List<Object?> get props => [query];
}

class AddProductEvent extends ProductEvent {
  final ProductModel product;

  const AddProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

class LoadSellerProducts extends ProductEvent {
  final String sellerId;

  const LoadSellerProducts({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}
