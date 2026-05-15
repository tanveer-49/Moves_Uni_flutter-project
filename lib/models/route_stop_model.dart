class RouteStopModel {
  final String stopId;
  final String stopName;
  final String stopTime;

  RouteStopModel({
    required this.stopId,
    required this.stopName,
    required this.stopTime,
  });

  factory RouteStopModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return RouteStopModel(
      stopId: map['stopId'] ?? '',
      stopName: map['stopName'] ?? '',
      stopTime: map['stopTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stopId': stopId,
      'stopName': stopName,
      'stopTime': stopTime,
    };
  }
}