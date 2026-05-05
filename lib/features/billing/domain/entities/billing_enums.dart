enum PaymentMethod { cash, phonePay }

enum PaymentStatus { pending, paid }

enum OrderStatus { pending, paid, cancelled }

extension PaymentMethodLabel on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.phonePay:
        return 'Phone Pay';
    }
  }
}

extension PaymentStatusLabel on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
    }
  }
}

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
