import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/cart_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MiniCatalogApp());
}

class MiniCatalogApp extends StatelessWidget {
  const MiniCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kicks.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.detail: (context) => const DetailScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
      },
    );
  }
}
