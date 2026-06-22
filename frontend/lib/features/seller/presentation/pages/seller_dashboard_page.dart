import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../../core/widgets/image_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_event.dart';
import '../../../product/presentation/bloc/product_state.dart';
import '../../../orders/presentation/bloc/orders_bloc.dart';
import '../../../orders/presentation/bloc/orders_event.dart';
import '../../../orders/presentation/bloc/orders_state.dart';
import '../../../orders/data/models/order_model.dart';

class SellerDashboardPage extends StatefulWidget {
  const SellerDashboardPage({super.key});

  @override
  State<SellerDashboardPage> createState() => _SellerDashboardPageState();
}

class _SellerDashboardPageState extends State<SellerDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _sellerId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    final authState = context.read<AuthBloc>().state;
    _sellerId = authState is Authenticated ? authState.user.uid : 'mock_seller_1';
    
    context.read<ProductBloc>().add(LoadSellerProducts(sellerId: _sellerId));
    context.read<OrdersBloc>().add(LoadSellerOrdersEvent(sellerId: _sellerId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2E2E50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTab() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is ProductsLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const Center(child: Text('No products listed yet.', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prod = products[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2E2E50)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: getImageProvider(prod.imageUrl), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prod.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('\$${prod.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: prod.stock > 3 ? AppColors.success.withOpacity(0.12) : AppColors.error.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: ${prod.stock}',
                        style: TextStyle(color: prod.stock > 3 ? AppColors.success : AppColors.error, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildOrdersTab() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is OrdersLoaded) {
          final orders = state.orders;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders received yet.', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final ord = orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2E2E50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${ord.id.substring(0, 5).toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('\$${ord.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Update Order Status:', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(height: 6),
                    
                    // Status change dropdown
                    DropdownButtonFormField<OrderStatus>(
                      value: ord.status,
                      dropdownColor: AppColors.darkSurface,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: OrderStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          context.read<OrdersBloc>().add(UpdateStatusEvent(orderId: ord.id, status: newStatus));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order Status updated to ${newStatus.toString().split('.').last}!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.secondary),
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.addProduct);
              if (mounted) {
                context.read<ProductBloc>().add(LoadSellerProducts(sellerId: _sellerId));
              }
            },
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stat overview row
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                _buildStatCard('Earnings', '\$488.99', Icons.attach_money, AppColors.success),
                const SizedBox(width: 12),
                _buildStatCard('Views', '1,248', Icons.visibility_outlined, AppColors.secondary),
                const SizedBox(width: 12),
                _buildStatCard('Rating', '4.8★', Icons.star_outline, AppColors.warning),
              ],
            ),
          ),

          // Tab Bar headers
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textMuted,
            tabs: const [
              Tab(text: 'My Inventory'),
              Tab(text: 'Customer Orders'),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInventoryTab(),
                _buildOrdersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
