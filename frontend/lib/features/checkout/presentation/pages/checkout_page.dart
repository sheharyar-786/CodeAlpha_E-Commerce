import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../product/data/models/product_model.dart';

class CheckoutPage extends StatefulWidget {
  final ProductModel? directProduct; // If buying directly from Details page

  const CheckoutPage({super.key, this.directProduct});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();

  String _paymentMethod = 'Stripe'; // Stripe or Razorpay or TestWallet
  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  void _onPayPressed(double totalAmount) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate secure tokenization & payment processing via Stripe/Razorpay API gateway
      await Future.delayed(const Duration(milliseconds: 2500));

      setState(() {
        _isProcessing = false;
      });

      // Show success screen
      if (mounted) {
        // Clear the cart on successful checkout
        context.read<CartBloc>().add(ClearCart());
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful! Thank you for your order.'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to Order History (in real app, we would pass order ID to tracking)
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
        Navigator.pushNamed(context, AppRoutes.orderHistory);
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
            hintText: 'Enter $label',
          ),
          validator: validator ?? (value) => value == null || value.isEmpty ? '$label is required' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Secure Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final double subtotal = widget.directProduct != null ? widget.directProduct!.price : state.subtotal;
          final double shipping = widget.directProduct != null ? 15.0 : state.shippingFee;
          final double tax = subtotal * 0.08;
          final double total = subtotal + shipping + tax;

          if (total <= 15.0 && widget.directProduct == null) {
            return const Center(child: Text('Nothing to checkout.'));
          }

          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Order Summary Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2E2E50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lock_outline, color: AppColors.secondary, size: 18),
                              SizedBox(width: 8),
                              Text('SSL Encrypted Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Payment Amount:', style: TextStyle(color: AppColors.textSecondary)),
                              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Shipping Details Section
                    const Text('Shipping Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    _buildTextField('Street Address', _addressController, Icons.home_outlined),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('City', _cityController, Icons.location_city)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField('ZIP Code', _zipController, Icons.pin_drop_outlined, keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Payment Method Options
                    const Text('Payment Method', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _paymentMethod = 'Stripe'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _paymentMethod == 'Stripe' ? AppColors.primary.withOpacity(0.15) : AppColors.darkCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: _paymentMethod == 'Stripe' ? AppColors.primary : const Color(0xFF2E2E50), width: 1.5),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.credit_card, color: Colors.white),
                                  SizedBox(height: 8),
                                  Text('Card (Stripe)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _paymentMethod = 'Razorpay'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _paymentMethod == 'Razorpay' ? AppColors.primary.withOpacity(0.15) : AppColors.darkCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: _paymentMethod == 'Razorpay' ? AppColors.primary : const Color(0xFF2E2E50), width: 1.5),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.account_balance_wallet, color: Colors.white),
                                  SizedBox(height: 8),
                                  Text('UPI (Razorpay)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Card Fields (if Stripe selected)
                    if (_paymentMethod == 'Stripe') ...[
                      const Text('Card Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      _buildTextField('Cardholder Name', _cardNameController, Icons.person_outline),
                      _buildTextField('Card Number', _cardNumberController, Icons.payment, keyboardType: TextInputType.number, validator: (v) {
                        if (v == null || v.isEmpty) return 'Card number is required';
                        if (v.length < 16) return 'Invalid card number';
                        return null;
                      }),
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Expiry (MM/YY)', _cardExpiryController, Icons.calendar_month, validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(v)) return 'Invalid';
                            return null;
                          })),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField('CVV', _cardCvvController, Icons.security, keyboardType: TextInputType.number, validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.length < 3) return 'Invalid';
                            return null;
                          })),
                        ],
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Secure Payment Submission
                    ElevatedButton(
                      onPressed: () => _onPayPressed(total),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.security, size: 20),
                          const SizedBox(width: 8),
                          Text('Pay \$${total.toStringAsFixed(2)} Securely'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Processing overlay
              if (_isProcessing)
                Positioned.fill(
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: AppColors.secondary),
                          const SizedBox(height: 24),
                          const Text(
                            'Tokenizing Payment Info...',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _paymentMethod == 'Stripe' 
                                ? 'Connecting to Stripe secure gateway...' 
                                : 'Authenticating Razorpay API transaction...',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
