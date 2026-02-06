import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'finance_repository.dart';
import 'invoice_model.dart';
import '../../core/components/main_layout.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

final invoicesProvider = StreamProvider((ref) => ref.watch(financeRepositoryProvider).invoicesStream);
final revenueProvider = FutureProvider((ref) => ref.watch(financeRepositoryProvider).getTotalRevenue());

class FinanceDashboard extends ConsumerWidget {
  const FinanceDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);
    final revenueAsync = ref.watch(revenueProvider);
    final currency = NumberFormat.simpleCurrency();

    return MainLayout(
      title: 'Finance & Accounting',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildKpiCard(context, 'Total Revenue', 
                   revenueAsync.value != null ? currency.format(revenueAsync.value) : '...'),
                const SizedBox(width: 16),
                _buildKpiCard(context, 'Pending Invoices', '0'), // Placeholder
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: invoicesAsync.when(
                  data: (invoices) {
                    if (invoices.isEmpty) {
                      return const Center(child: Text("No invoices recorded."));
                    }
                    return DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(label: Text('Invoice #'), size: ColumnSize.S),
                        DataColumn2(label: Text('Customer'), size: ColumnSize.L),
                        DataColumn2(label: Text('Amount'), numeric: true),
                        DataColumn2(label: Text('Status')),
                        DataColumn2(label: Text('Due Date')),
                      ],
                      rows: invoices.map((inv) => DataRow(cells: [
                        DataCell(Text(inv.id.substring(0, 8))), // Show short ID
                        DataCell(Text(inv.customerName)),
                        DataCell(Text(currency.format(inv.totalAmount))),
                        DataCell(_buildStatusChip(inv.status)),
                        DataCell(Text(DateFormat('MMM dd, yyyy').format(inv.dueDate))),
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
  
   Widget _buildStatusChip(String status) {
     Color color = Colors.grey;
     if (status == 'paid') color = Colors.green;
     if (status == 'overdue') color = Colors.red;
     if (status == 'sent') color = Colors.blue;
     
     return Chip(
        label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10)),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(color: color),
        padding: EdgeInsets.zero,
     );
  }
}
