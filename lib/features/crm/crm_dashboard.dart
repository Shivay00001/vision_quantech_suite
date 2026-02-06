import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'crm_repository.dart';
import 'lead_model.dart';
import '../../core/components/main_layout.dart';
import 'package:data_table_2/data_table_2.dart';

final leadsProvider = StreamProvider((ref) => ref.watch(crmRepositoryProvider).leadsStream);

class CrmDashboard extends ConsumerWidget {
  const CrmDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(leadsProvider);

    return MainLayout(
      title: 'CRM Dashboard',
      child: Column(
        children: [
          // KPI Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildKpiCard(context, 'Total Leads', '0'), // Placeholder for async data
                const SizedBox(width: 16),
                _buildKpiCard(context, 'Conversion Rate', '0%'),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: leadsAsync.when(
                  data: (leads) {
                    if (leads.isEmpty) {
                      return const Center(child: Text("No leads yet."));
                    }
                    return DataTable2(
                      columns: const [
                        DataColumn2(label: Text('Name'), size: ColumnSize.L),
                        DataColumn2(label: Text('Status')),
                        DataColumn2(label: Text('Value'), numeric: true),
                        DataColumn2(label: Text('Created At')),
                      ],
                      rows: leads.map((lead) => DataRow(cells: [
                        DataCell(Text(lead.name)),
                        DataCell(Chip(
                          label: Text(lead.status), 
                          backgroundColor: _getStatusColor(lead.status).withOpacity(0.2),
                          labelStyle: TextStyle(color: _getStatusColor(lead.status)),
                        )),
                        DataCell(Text('\$${lead.value}')),
                        DataCell(Text(lead.createdAt.toIso8601String().split('T')[0])),
                      ])).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(BuildContext context, String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'won': return Colors.green;
      case 'lost': return Colors.red;
      case 'new': return Colors.blue;
      default: return Colors.orange;
    }
  }
}
