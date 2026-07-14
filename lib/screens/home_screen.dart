import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = [
    'All',
    'Basketball',
    'Court',
    'Skate',
    'Trail',
    'Lifestyle',
    'Casual',
  ];

  List<Product> _products = [];
  bool _loading = true;
  String _query = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await ProductRepository.loadProducts();
    if (!mounted) return;
    setState(() {
      _products = products;
      _loading = false;
    });
  }

  List<Product> _filteredProducts() {
    final query = _query.trim().toLowerCase();
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kicks.', style: AppTextStyles.display),
        actions: const [_CartAction(), SizedBox(width: 8)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.ink))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final filtered = _filteredProducts();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        const Text('Find your next pair.', style: AppTextStyles.meta),
        const SizedBox(height: 14),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          style: const TextStyle(fontSize: 14, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: 'Search by name or brand',
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.muted),
            prefixIcon: const Icon(Icons.search, color: AppColors.muted),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppColors.kraft.withValues(alpha: 0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.ink),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/banner.jpg', fit: BoxFit.cover),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    color: AppColors.kraft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      'SEASON DROP / 02',
                      style: AppTextStyles.mono(size: 11, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CategoryChips(
          categories: _categories,
          selected: _selectedCategory,
          onSelected: (category) =>
              setState(() => _selectedCategory = category),
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                'No pairs match that search.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.66,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final product = filtered[index];
              return ProductCard(
                product: product,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.detail,
                  arguments: product,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _CartAction extends StatelessWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartState.instance,
      builder: (context, child) {
        final count = CartState.instance.totalCount;
        return Stack(
          children: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: 'Cart',
            ),
            if (count > 0)
              Positioned(
                right: 2,
                top: 2,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    constraints: const BoxConstraints(minWidth: 18),
                    decoration: BoxDecoration(
                      color: AppColors.flare,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mono(size: 10, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
