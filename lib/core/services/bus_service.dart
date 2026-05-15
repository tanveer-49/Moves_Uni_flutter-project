import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/bus_model.dart';

class BusService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String collection = 'buses';

  /// ADD BUS
  Future<void> addBus(BusModel bus) async {
    try {
      await _firestore
          .collection(collection)
          .doc(bus.busId)
          .set(bus.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE BUS
  Future<void> updateBus(BusModel bus) async {
    try {
      await _firestore
          .collection(collection)
          .doc(bus.busId)
          .update(bus.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE BUS
  Future<void> deleteBus(String busId) async {
    try {
      await _firestore
          .collection(collection)
          .doc(busId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  /// GET ALL BUSES
  Stream<List<BusModel>> getBuses() {
    return _firestore
        .collection(collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BusModel.fromMap(doc.data());
      }).toList();
    });
  }
}