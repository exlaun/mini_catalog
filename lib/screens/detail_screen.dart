import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/product.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _selectedSize;

  void _addToCart(Product product) {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final size = _selectedSize;
    if (size == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Pick a size first.')),
      );
      return;
    }
    CartState.instance.add(product, size);
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Added to cart.'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => navigator.pushNamed(AppRoutes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: AppColors.photoBackdrop,
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product.brand.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(product.name, style: AppTextStyles.display),
          const SizedBox(height: 8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: AppTextStyles.mono(size: 20, color: AppColors.flare),
          ),
          const SizedBox(height: 24),
          const Text('DESCRIPTION', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 8),
          Text(product.description, style: AppTextStyles.body),
          const SizedBox(height: 24),
          const Text('SPECIFICATIONS', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.kraft.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.kraft),
            ),
            child: Column(
              children: [
                _SpecRow(label: 'SKU', value: product.sku),
                _SpecRow(label: 'COLORWAY', value: product.colorway),
                _SpecRow(
                  label: 'RATING',
                  value: '${product.rating.toStringAsFixed(1)} / 5',
                ),
                _SpecRow(label: 'CATEGORY', value: product.category),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('SELECT SIZE', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final size in product.sizes)
                _SizeChip(
                  size: size,
                  isSelected: size == _selectedSize,
                  onTap: () => setState(() => _selectedSize = size),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.kraft.withValues(alpha: 0.4)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _addToCart(product),
              child: const Text('Add to cart'),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTextStyles.mono(
                size: 11,
                color: AppColors.muted,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.toUpperCase(),
              style: AppTextStyles.mono(size: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.flare : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide.none
            : BorderSide(color: AppColors.kraft.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            size,
            style: AppTextStyles.mono(
              size: 13,
              color: isSelected ? Colors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
