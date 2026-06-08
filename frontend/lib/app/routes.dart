import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderHistory = '/orders';
  static const String orderTracking = '/order-tracking';
  
  // Seller Routes
  static const String sellerDashboard = '/seller/dashboard';
  static const String addProduct = '/seller/add-product';

  // Navigation Helper
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // We will map pages here as we build them.
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
