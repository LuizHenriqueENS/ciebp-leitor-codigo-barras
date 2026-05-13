class History {
  DateTime sellDate;
  double sellValue;

  History({required this.sellDate, required this.sellValue});

  Map<String, dynamic> toJson() => {
    'selldate': sellDate.toUtc().toString(),
    'sellvalue': sellValue,
  };

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      sellDate: DateTime.parse(json['selldate']),
      sellValue: json['sellvalue'],
    );
  }
}
