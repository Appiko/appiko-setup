class MetaStructure {
  MetaStructure();
  List advancedOptionsEnabled = List.filled(9, false);
  bool radioAdvancedOption = false;

  Map<String, dynamic> toJson() => {
        'advancedOptionsEnabled': advancedOptionsEnabled,
        'radioAdvancedOption': radioAdvancedOption,
      };

  MetaStructure.fromJson(Map<String, dynamic> json)
      : advancedOptionsEnabled = json['advancedOptionsEnabled'],
        radioAdvancedOption = json['radioAdvancedOption'];

  @override
  String toString() {
    return "$advancedOptionsEnabled\n$radioAdvancedOption";
  }
}
