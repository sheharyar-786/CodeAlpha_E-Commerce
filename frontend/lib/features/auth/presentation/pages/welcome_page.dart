import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.darkBackground,
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1472851294608-062f824d296e?q=80&w=600&auto=format&fit=crop',
            ),
            opacity: 0.15,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                
                // Brand logo / Symbol
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => AppGradients.primaryGradient.createShader(bounds),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Brand Name
                ShaderMask(
                  shaderCallback: (bounds) => AppGradients.primaryGradient.createShader(bounds),
                  child: Text(
                    'NovaMarket',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'The Premium Peer-to-Peer E-Commerce Platform',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                ),
                
                const Spacer(flex: 3),
                
                // Welcome Card (glassmorphism feel)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF2E2E50), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Secure Buying & Selling',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Join thousands of verified traders. Experience instant payments and live order tracking.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Get Started / Register Button (Vibrant Gradient)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Sign In Button (Transparent / Outline)
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          side: const BorderSide(color: Color(0xFF2E2E50), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
