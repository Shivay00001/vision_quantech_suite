class Lead {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status; // 'new', 'contacted', 'qualified', 'proposal', 'won', 'lost'
  final double value;
  final String? assignedTo;
  final String organizationId;
  final DateTime createdAt;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.value,
    this.assignedTo,
    required this.organizationId,
    required this.createdAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? 'new',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      assignedTo: json['assigned_to'],
      organizationId: json['organization_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'status': status,
      'value': value,
      'place': phone, // assuming mapping or just phone
    };
  }
}
