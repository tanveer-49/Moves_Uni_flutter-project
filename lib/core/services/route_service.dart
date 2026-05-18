import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/route_stop_model.dart';

class RouteService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String busesCollection = 'buses';

  /// ADD STOP
  Future<void> addStop({
    required String busId,
    required String routeType,
    required RouteStopModel stop,
  }) async {

    try {

      await _firestore
          .collection(busesCollection)
          .doc(busId)
          .collection(routeType)
          .doc(stop.stopId)
          .set(stop.toMap());

    } catch (e) {

      rethrow;
    }
  }

  /// UPDATE STOP
  Future<void> updateStop({
    required String busId,
    required String routeType,
    required RouteStopModel stop,
  }) async {

    try {

      await _firestore
          .collection(busesCollection)
          .doc(busId)
          .collection(routeType)
          .doc(stop.stopId)
          .update(stop.toMap());

    } catch (e) {

      rethrow;
    }
  }

  /// DELETE STOP
  Future<void> deleteStop({
    required String busId,
    required String routeType,
    required String stopId,
  }) async {

    try {

      await _firestore
          .collection(busesCollection)
          .doc(busId)
          .collection(routeType)
          .doc(stopId)
          .delete();

    } catch (e) {

      rethrow;
    }
  }

  /// GET ROUTE STOPS
  Stream<List<RouteStopModel>> getStops({
    required String busId,
    required String routeType,
  }) {

    return _firestore
        .collection(busesCollection)
        .doc(busId)
        .collection(routeType)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return RouteStopModel.fromMap(
          doc.data(),
        );

      }).toList();
    });
  }
}