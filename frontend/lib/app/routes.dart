import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/product/presentation/pages/home_page.dart';
import '../features/product/presentation/pages/product_detail_page.dart';
import '../features/product/data/models/product_model.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/checkout/presentation/pages/checkout_page.dart';
import '../features/orders/presentation/pages/order_history_page.dart';
import '../features/orders/presentation/pages/order_tracking_page.dart';
import '../features/orders/data/models/order_model.dart';
import '../features/seller/presentation/pages/seller_dashboard_page.dart';
import '../features/seller/presentation/pages/add_product_page.dart';

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
        return MaterialPageRoute(builder: (_) => const SplashPage());
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
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case checkout:
        return MaterialPageRoute(
          builder: (_) => CheckoutPage(
            directProduct: settings.arguments as ProductModel?,
          ),
        );
      case orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryPage());
      case orderTracking:
        return MaterialPageRoute(
          builder: (_) => OrderTrackingPage(
            order: settings.arguments as OrderModel,
          ),
        );
      case sellerDashboard:
        return MaterialPageRoute(builder: (_) => const SellerDashboardPage());
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductPage());
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
