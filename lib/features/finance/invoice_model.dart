class Invoice {
  final String id;
  final String customerName;
  final double totalAmount;
  final String status; // 'draft', 'sent', 'paid', 'overdue'
  final DateTime issueDate;
  final DateTime dueDate;
  final String organizationId;
  final List<InvoiceItem> items;

  Invoice({
    required this.id,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.issueDate,
    required this.dueDate,
    required this.organizationId,
    this.items = const [],
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    var itemsList = <InvoiceItem>[];
    if (json['items'] != null) {
      itemsList = (json['items'] as List).map((i) => InvoiceItem.fromJson(i)).toList();
    }

    return Invoice(
      id: json['id'],
      customerName: json['customer_name'] ?? 'Unknown',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'draft',
      issueDate: DateTime.parse(json['issue_date']),
      dueDate: DateTime.parse(json['due_date']),
      organizationId: json['organization_id'],
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'total_amount': totalAmount,
      'status': status,
      'issue_date': issueDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
    };
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  InvoiceItem({required this.description, required this.quantity, required this.unitPrice});

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}
