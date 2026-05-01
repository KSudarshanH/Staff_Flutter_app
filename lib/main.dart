import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contexts/auth_provider.dart';
import 'models/models.dart';
import 'contexts/orders_provider.dart';
import 'contexts/tables_provider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/new_orders_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/bill_screen.dart';

import 'contexts/menu_provider.dart';
import 'screens/create_order_screen.dart';

void main() {
  runApp(const RestaurantOSApp());
}

class RestaurantOSApp extends StatelessWidget {
  const RestaurantOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ AuthProvider FIRST
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // ✅ OrdersProvider (NO API CALL HERE)
        ChangeNotifierProvider(create: (_) => OrdersProvider()),

        // ✅ TablesProvider
        ChangeNotifierProvider(create: (_) => TablesProvider()),

        // ✅ MenuProvider
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'RestaurantOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            scrollBehavior: const _NoGlowScrollBehavior(),

            // 🔥 AUTO ROUTE BASED ON LOGIN
            initialRoute: !auth.isLoggedIn 
                ? '/login' 
                : (auth.role == StaffRole.billingStaff ? '/billing' : '/dashboard'),

            onGenerateRoute: (settings) {
              Widget page;
              switch (settings.name) {
                case '/login':
                  page = const LoginScreen();
                  break;

                case '/dashboard':
                case '/billing':
                  page = const MainScaffold();
                  break;

                case '/new-orders':
                  page = const NewOrdersScreen();
                  break;

                case '/create-order':
                  page = const CreateOrderScreen();
                  break;

                case '/orders':
                  page = const MainScaffold(initialTab: 1);
                  break;

                case '/tables':
                  page = const MainScaffold(initialTab: 2);
                  break;

                case '/profile':
                  page = const MainScaffold(initialTab: 3);
                  break;

                case '/order-details':
                  final orderId = settings.arguments as String? ?? '';
                  page = OrderDetailsScreen(orderId: orderId);
                  break;

                case '/payment':
                  final orderId = settings.arguments as String? ?? '';
                  page = PaymentScreen(orderId: orderId);
                  break;

                case '/bill':
                  final args =
                      settings.arguments as Map<String, dynamic>? ?? {};
                  page = BillScreen(
                    orderId: args['orderId'] as String? ?? '',
                    tipAmount: args['tipAmount'] as int? ?? 0,
                    finalTotal: args['finalTotal'] as int? ?? 0,
                    paymentMethod:
                        args['paymentMethod'] as String? ?? 'cash',
                  );
                  break;

                default:
                  page = const LoginScreen();
              }

              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.05, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              );
            },
          );
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