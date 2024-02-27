class StripePaymentIntent {
  const StripePaymentIntent({
    this.id,
    this.clientSecret,
    this.status,
    this.customerId,
    this.customerEphemeralKeySecret,
    this.setupIntentClientSecret,
  });

  final String? id;
  final String? clientSecret;
  final String? status;
  final String? customerId;
  final String? customerEphemeralKeySecret;
  final String? setupIntentClientSecret;

  bool get isSucceeded => status == 'succeeded';
}
