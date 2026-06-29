import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProductsQuery>(_onSearchProductsQuery);
    on<AddProductEvent>(_onAddProduct);
    on<LoadSellerProducts>(_onLoadSellerProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      // Auto-seed Firestore database if empty
      await _productRepository.seedProductsIfEmpty();
      
      final products = await _productRepository.fetchProducts(category: event.category);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchProductsQuery(
    SearchProductsQuery event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.searchProducts(event.query);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _productRepository.addProduct(event.product);
      emit(ProductOperationSuccess());
    } catch (e) {
      emit(ProductFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadSellerProducts(
    LoadSellerProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.fetchSellerProducts(event.sellerId);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductFailure(errorMessage: e.toString()));
    }
  }
}
