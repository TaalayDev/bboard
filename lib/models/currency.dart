class Currency {
  final int id;
  final String name;
  final String symbol;

  const Currency({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory Currency.fromMap(map) => Currency(
        id: map['id'] ?? 0,
        name: map['name'],
        symbol: map['symbol'],
      );
}
