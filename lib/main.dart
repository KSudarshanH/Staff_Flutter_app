import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contexts/auth_provider.dart';
import 'contexts/orders_provider.dart';
import 'contexts/tables_provider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/new_orders_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/bill_screen.dart';

void main() {
  runApp(const RestaurantOSApp());
}

class RestaurantOSApp extends StatelessWidget {
  const RestaurantOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => TablesProvider()),
      ],
      child: MaterialApp(
        title: 'RestaurantOS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        scrollBehavior: const _NoGlowScrollBehavior(),
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());

            case '/dashboard':
            case '/billing':
              return MaterialPageRoute(builder: (_) => const MainScaffold());

            case '/new-orders':
              return MaterialPageRoute(builder: (_) => const NewOrdersScreen());

            case '/orders':
              return MaterialPageRoute(
                builder: (_) => const MainScaffold(initialTab: 1),
              );

            case '/tables':
              return MaterialPageRoute(
                builder: (_) => const MainScaffold(initialTab: 2),
              );

            case '/profile':
              return MaterialPageRoute(
                builder: (_) => const MainScaffold(initialTab: 3),
              );

            case '/order-details':
              final orderId = settings.arguments as String? ?? '';
              return MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(orderId: orderId),
              );

            case '/payment':
              final orderId = settings.arguments as String? ?? '';
              return MaterialPageRoute(
                builder: (_) => PaymentScreen(orderId: orderId),
              );

            case '/bill':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => BillScreen(
                  orderId: args['orderId'] as String? ?? '',
                  tipAmount: args['tipAmount'] as int? ?? 0,
                  finalTotal: args['finalTotal'] as int? ?? 0,
                  paymentMethod: args['paymentMethod'] as String? ?? 'cash',
                ),
              );

            default:
              return MaterialPageRoute(builder: (_) => const LoginScreen());
          }
        },
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
