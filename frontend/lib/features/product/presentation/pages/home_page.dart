import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme.dart';
import '../../../../app/theme_cubit.dart';
import '../../../../app/routes.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/product_model.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view},
    {'name': 'Electronics', 'icon': Icons.bolt},
    {'name': 'Fashion', 'icon': Icons.checkroom},
    {'name': 'Accessories', 'icon': Icons.watch},
    {'name': 'Home', 'icon': Icons.kitchen},
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    context.read<ProductBloc>().add(LoadProducts(category: category == 'All' ? null : category));
  }

  void _onSearchChanged(String query) {
    context.read<ProductBloc>().add(SearchProductsQuery(query: query));
  }

  Widget _buildCategoryChip(String name, IconData icon) {
    final isSelected = _selectedCategory == name;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _onCategorySelected(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary 
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : (isDark ? const Color(0xFF2E2E50) : Colors.grey.shade300),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected 
                  ? Colors.white 
                  : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? Colors.white 
                    : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetail,
          arguments: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF2E2E50) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Category badge
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'product-image-${product.id}',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.darkBackground : AppColors.lightBackground).withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 16, color: AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${product.sellerName}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textMuted : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.secondary : AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.warning),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              String name = 'Shopper';
                              UserRole role = UserRole.buyer;
                              if (state is Authenticated) {
                                name = state.user.name;
                                role = state.user.role;
                              }
                              final isDark = Theme.of(context).brightness == Brightness.dark;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, $name!',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    role == UserRole.seller 
                                        ? 'Seller Portal active'
                                        : 'Explore custom handpicks for you',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textMuted : AppColors.lightTextSecondary, 
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Action Buttons (Theme / Cart / Dashboard / Logout)
                        Row(
                          children: [
                            BlocBuilder<ThemeCubit, ThemeMode>(
                              builder: (context, mode) {
                                final isDark = mode == ThemeMode.dark;
                                return IconButton(
                                  icon: Icon(
                                    isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                  ),
                                  onPressed: () {
                                    context.read<ThemeCubit>().toggleTheme();
                                  },
                                  tooltip: 'Toggle Theme',
                                );
                              },
                            ),
                            BlocBuilder<CartBloc, CartState>(
                              builder: (context, state) {
                                final count = state.itemCount;
                                final isDark = Theme.of(context).brightness == Brightness.dark;
                                return Badge(
                                  isLabelVisible: count > 0,
                                  label: Text(count.toString()),
                                  backgroundColor: AppColors.accent,
                                  textColor: Colors.white,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.shopping_cart_outlined, 
                                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                    ),
                                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isSeller = state is Authenticated && 
                                    (state.user.role == UserRole.seller || state.user.role == UserRole.both);
                                final isDark = Theme.of(context).brightness == Brightness.dark;
                                if (isSeller) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.storefront_outlined, 
                                      color: isDark ? AppColors.secondary : AppColors.primary,
                                    ),
                                    onPressed: () => Navigator.pushNamed(context, AppRoutes.sellerDashboard),
                                    tooltip: 'Seller Dashboard',
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: AppColors.error),
                              onPressed: () {
                                context.read<AuthBloc>().add(SignOutRequested());
                                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.lightTextPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search products, electronics, gear...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune, color: AppColors.primary),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Promo Banner
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: 150,
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '30% SPECIAL DISCOUNT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Upgrade Your Sound',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Use code SOUND30 at checkout.',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category header
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18, 
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category List
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories
                            .map((cat) => _buildCategoryChip(cat['name'], cat['icon']))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const ShimmerLoader();
                } else if (state is ProductsLoaded) {
                  final products = state.products;
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'No products found',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.73,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index]);
                    },
                  );
                } else if (state is ProductFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
