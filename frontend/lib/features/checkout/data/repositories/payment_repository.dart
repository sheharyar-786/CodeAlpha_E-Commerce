import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PaymentRepository {
  // Use 127.0.0.1 for iOS / Physical Android with 'adb reverse tcp:5000 tcp:5000'
  // and fallback to 10.0.2.2 for Android Emulator.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000';
    return 'http://127.0.0.1:5000';
  }

  Future<Map<String, dynamic>?> createStripePaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/payments/stripe/create-payment-intent');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'orderId': orderId,
        }),
      ).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('Failed to create payment intent: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error communicating with localhost backend, trying Android loopback: $e');
      try {
        final fallbackUrl = Uri.parse('http://10.0.2.2:5000/api/payments/stripe/create-payment-intent');
        final response = await http.post(
          fallbackUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'amount': amount,
            'currency': currency,
            'orderId': orderId,
          }),
        ).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          return jsonDecode(response.body) as Map<String, dynamic>;
        }
      } catch (err) {
        debugPrint('Fallback to Android loopback failed: $err');
      }
      return null;
    }
  }
}
