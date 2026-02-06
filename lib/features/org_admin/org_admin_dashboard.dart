import 'package:flutter/material.dart';
import '../../core/components/main_layout.dart';

class OrgAdminDashboard extends StatelessWidget {
  const OrgAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'Organization Dashboard',
      child: Center(child: Text('Org Admin Dashboard Content')),
    );
  }
}
