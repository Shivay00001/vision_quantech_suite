import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lead_model.dart';
import 'package:fpdart/fpdart.dart';

final crmRepositoryProvider = Provider((ref) => CrmRepository(Supabase.instance.client));

class CrmRepository {
  final SupabaseClient _supabase;

  CrmRepository(this._supabase);

  Future<List<Lead>> getLeads() async {
    final data = await _supabase.from('leads').select().order('created_at');
    return (data as List).map((e) => Lead.fromJson(e)).toList();
  }

  Future<Either<String, Lead>> createLead(Map<String, dynamic> leadData) async {
    try {
      final response = await _supabase.from('leads').insert(leadData).select().single();
      return right(Lead.fromJson(response));
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> updateLeadStatus(String leadId, String status) async {
    await _supabase.from('leads').update({'status': status}).eq('id', leadId);
  }
  
  // Real-time stream
  Stream<List<Lead>> get leadsStream {
    return _supabase.from('leads').stream(primaryKey: ['id']).map((event) 
      => event.map((e) => Lead.fromJson(e)).toList()
    );
  }
}
