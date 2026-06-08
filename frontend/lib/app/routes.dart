import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/product/presentation/pages/home_page.dart';
import '../features/product/presentation/pages/product_detail_page.dart';
import '../features/product/data/models/product_model.dart';

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
      case splash:
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case productDetail:
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(
            product: settings.arguments as ProductModel,
          ),
        );
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


