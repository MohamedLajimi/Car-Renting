enum Currency {
  tnd,
  eur,
  usd;

  static Currency fromMap(String? name) {
    if (name == null) return Currency.tnd;

    final cleanName = name.trim().toLowerCase();

    return Currency.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => Currency.tnd,
    );
  }

  String get displayName {
    return switch (this) {
      Currency.tnd => 'DT',
      Currency.eur => 'EUR',
      Currency.usd => 'USD',
    };
  }

  String get symbol {
    return switch (this) {
      Currency.tnd => 'DT',
      Currency.eur => '€',
      Currency.usd => '\$',
    };
  }
}
