import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../data/models/order_model.dart';

class OrderTrackingPage extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingPage({super.key, required this.order});

  int _getStatusStepIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.ordered:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
    }
  }

  Widget _buildStepIndicator(int stepIndex, int currentStep, String title, String subtitle, IconData icon) {
    final isDone = stepIndex <= currentStep;
    final isCurrent = stepIndex == currentStep;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stepper Visuals (Dot & Line)
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : AppColors.darkCard,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent 
                      ? AppColors.secondary 
                      : (isDone ? AppColors.primary : const Color(0xFF2E2E50)),
                  width: 2,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDone ? Colors.white : AppColors.textMuted,
              ),
            ),
            if (stepIndex < 3)
              Container(
                width: 2,
                height: 50,
                color: stepIndex < currentStep ? AppColors.primary : const Color(0xFF2E2E50),
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // Step details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDone ? Colors.white : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isCurrent ? AppColors.secondary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getStatusStepIndex(order.status);
    
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Track Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Order Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF2E2E50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated Delivery', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    Text(
                      order.status == OrderStatus.delivered ? 'Delivered' : 'In 2-4 Days',
                      style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Order Shipment Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF2E2E50), height: 1),
                const SizedBox(height: 16),
                
                // Stepper
                _buildStepIndicator(
                  0,
                  currentStep,
                  'Order Placed',
                  'We have received your order.',
                  Icons.receipt_long_outlined,
                ),
                _buildStepIndicator(
                  1,
                  currentStep,
                  'Processing',
                  'Your seller is packaging your items.',
                  Icons.inventory_2_outlined,
                ),
                _buildStepIndicator(
                  2,
                  currentStep,
                  'Shipped',
                  'Item handed over to local courier service.',
                  Icons.local_shipping_outlined,
                ),
                _buildStepIndicator(
                  3,
                  currentStep,
                  'Delivered',
                  'Package delivered to your shipping address.',
                  Icons.home_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Shipping Address Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF2E2E50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shipping Destination', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.pin_drop_outlined, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.shippingAddress,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Order Items Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF2E2E50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Items', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                const SizedBox(height: 16),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('${item.quantity} x \$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
