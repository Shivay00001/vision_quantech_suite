import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'invoice_model.dart';

final financeRepositoryProvider = Provider((ref) => FinanceRepository(Supabase.instance.client));

class FinanceRepository {
  final SupabaseClient _supabase;

  FinanceRepository(this._supabase);

  Stream<List<Invoice>> get invoicesStream {
     return _supabase.from('invoices').stream(primaryKey: ['id']).map((event) 
      => event.map((e) => Invoice.fromJson(e)).toList()
    );
  }

  Future<void> createInvoice(Map<String, dynamic> invoiceData) async {
    await _supabase.from('invoices').insert(invoiceData);
  }
  
  // Example for calculating real-time revenue stats
  // For simplicity, we might just sum in the UI or fetch an aggregation
  Future<double> getTotalRevenue() async {
    try {
      // Supabase doesn't support sum() in simple SELECT without function or grouping in standard postgrest-js as easily, 
      // but we can fetch all paid invoices and sum. Ideally use an RPC or View.
      // For this implementation, we will fetch and reduce client side (assuming relatively low volume for MVP)
      final data = await _supabase.from('invoices').select('total_amount').eq('status', 'paid');
      double total = 0;
      for(var row in (data as List)) {
        total += (row['total_amount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }
}
