class BusModel {
  final String busId;
  final String busCode;
  final String plateNumber;
  final String driverName;

  BusModel({
    required this.busId,
    required this.busCode,
    required this.plateNumber,
    required this.driverName,
  });

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      busId: map['busId'] ?? '',
      busCode: map['busCode'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      driverName: map['driverName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'busId': busId,
      'busCode': busCode,
      'plateNumber': plateNumber,
      'driverName': driverName,
    };
  }

  // ✅ IMPORTANT: Add this for DropdownButton to work properly
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusModel && other.busId == busId;
  }

  @override
  int get hashCode => busId.hashCode;
}