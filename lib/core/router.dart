import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/superadmin/superadmin_dashboard.dart';
import '../features/org_admin/org_admin_dashboard.dart';
import '../features/employee/employee_dashboard.dart';
import '../features/crm/crm_dashboard.dart';
import '../features/hr/hr_dashboard.dart';
import '../features/finance/finance_dashboard.dart';
import '../features/inventory/inventory_dashboard.dart';
import 'models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
    redirect: (context, state) async {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggingIn = state.uri.toString() == '/login';

      if (session == null) {
        return isLoggingIn ? null : '/login';
      }

      // Role Based Redirects
      if (isLoggingIn || state.uri.toString() == '/') {
         final profile = await ref.read(authControllerProvider.notifier).fetchProfileForRedirect(session.user.id);
         if (profile == null) return '/login'; // Safety fallback

         switch (UserRole.fromString(profile.role)) {
          case UserRole.developer:
            return '/superadmin';
          case UserRole.org_admin:
            return '/admin';
          case UserRole.crm_manager:
            return '/crm';
          case UserRole.hr_manager:
            return '/hr';
          case UserRole.finance_manager:
            return '/finance';
          case UserRole.inventory_manager:
            return '/inventory';
          case UserRole.employee:
            return '/employee';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/superadmin',
        builder: (context, state) => const SuperAdminDashboard(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const OrgAdminDashboard(),
      ),
      GoRoute(
        path: '/employee',
        builder: (context, state) => const EmployeeDashboard(),
      ),
      GoRoute(
        path: '/crm',
        builder: (context, state) => const CrmDashboard(),
      ),
      GoRoute(
        path: '/hr',
        builder: (context, state) => const HrDashboard(),
      ),
      GoRoute(
        path: '/finance',
        builder: (context, state) => const FinanceDashboard(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryDashboard(),
      ),
    ],
  );
});

// Helper for GoRouter refresh listenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}



