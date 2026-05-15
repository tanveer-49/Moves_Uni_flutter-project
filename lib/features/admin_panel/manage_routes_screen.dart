import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/route_service.dart';
import '../../models/bus_model.dart';
import '../../models/route_stop_model.dart';

class ManageRoutesScreen extends StatefulWidget {
  const ManageRoutesScreen({super.key});

  @override
  State<ManageRoutesScreen> createState() =>
      _ManageRoutesScreenState();
}

class _ManageRoutesScreenState
    extends State<ManageRoutesScreen> {

  final RouteService _routeService = RouteService();

  final stopNameController = TextEditingController();
  final stopTimeController = TextEditingController();

  String routeType = 'morningRoute';

  BusModel? selectedBus;

  bool isLoading = false;

  String? editingStopId;

  /// LOAD BUSES
  Stream<List<BusModel>> getBuses() {
    return FirebaseFirestore.instance
        .collection('buses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BusModel.fromMap(doc.data());
      }).toList();
    });
  }

  /// SAVE STOP
  Future<void> saveStop() async {

    if (selectedBus == null) {
      showMessage('Please select a bus');
      return;
    }

    if (stopNameController.text.trim().isEmpty ||
        stopTimeController.text.trim().isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final stop = RouteStopModel(
        stopId: editingStopId ?? const Uuid().v4(),
        stopName: stopNameController.text.trim(),
        stopTime: stopTimeController.text.trim(),
      );

      if (editingStopId == null) {

        await _routeService.addStop(
          busId: selectedBus!.busId,
          routeType: routeType,
          stop: stop,
        );

      } else {

        await _routeService.updateStop(
          busId: selectedBus!.busId,
          routeType: routeType,
          stop: stop,
        );
      }

      clearFields();

      showMessage(
        editingStopId == null
            ? 'Stop Added'
            : 'Stop Updated',
      );

    } catch (e) {
      showMessage(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// EDIT STOP
  void editStop(RouteStopModel stop) {

    editingStopId = stop.stopId;

    stopNameController.text = stop.stopName;
    stopTimeController.text = stop.stopTime;

    setState(() {});
  }

  /// DELETE STOP
  Future<void> deleteStop(String stopId) async {

    try {

      await _routeService.deleteStop(
        busId: selectedBus!.busId,
        routeType: routeType,
        stopId: stopId,
      );

      showMessage('Stop Deleted');

    } catch (e) {
      showMessage(e.toString());
    }
  }

  /// CLEAR
  void clearFields() {

    stopNameController.clear();
    stopTimeController.clear();

    editingStopId = null;
  }

  /// MESSAGE
  void showMessage(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text('Manage Routes'),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// LEFT SIDE FORM
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Manage Routes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUS DROPDOWN
                    StreamBuilder<List<BusModel>>(
                      stream: getBuses(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final buses =
                            snapshot.data ?? [];

                        return DropdownButtonFormField<
                            BusModel>(
                          value: selectedBus,
                          decoration:
                          const InputDecoration(
                            labelText: 'Select Bus',
                            border:
                            OutlineInputBorder(),
                          ),
                          items: buses.map((bus) {

                            return DropdownMenuItem(
                              value: bus,
                              child: Text(
                                bus.busCode,
                              ),
                            );

                          }).toList(),
                          onChanged: (value) {

                            setState(() {
                              selectedBus = value;
                            });
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// ROUTE TYPE
                    DropdownButtonFormField<String>(
                      value: routeType,
                      decoration:
                      const InputDecoration(
                        labelText: 'Route Type',
                        border:
                        OutlineInputBorder(),
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: 'morningRoute',
                          child: Text('Morning Route'),
                        ),

                        DropdownMenuItem(
                          value: 'eveningRoute',
                          child: Text('Evening Route'),
                        ),
                      ],
                      onChanged: (value) {

                        setState(() {
                          routeType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    /// STOP NAME
                    TextField(
                      controller:
                      stopNameController,
                      decoration:
                      const InputDecoration(
                        labelText: 'Stop Name',
                        border:
                        OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// STOP TIME
                    TextField(
                      controller:
                      stopTimeController,
                      decoration:
                      const InputDecoration(
                        labelText: 'Stop Time',
                        border:
                        OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                        isLoading
                            ? null
                            : saveStop,
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.green,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          editingStopId == null
                              ? 'Add Stop'
                              : 'Update Stop',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 20),

            /// RIGHT SIDE LIST
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: selectedBus == null
                    ? const Center(
                  child: Text(
                    'Select a bus to view routes',
                  ),
                )
                    : StreamBuilder<List<RouteStopModel>>(
                  stream:
                  _routeService.getStops(
                    busId:
                    selectedBus!.busId,
                    routeType:
                    routeType,
                  ),
                  builder:
                      (context, snapshot) {

                    if (snapshot
                        .connectionState ==
                        ConnectionState
                            .waiting) {

                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {

                      return Center(
                        child: Text(
                          snapshot.error
                              .toString(),
                        ),
                      );
                    }

                    final stops =
                        snapshot.data ?? [];

                    if (stops.isEmpty) {

                      return const Center(
                        child: Text(
                          'No stops found',
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount:
                      stops.length,
                      itemBuilder:
                          (context, index) {

                        final stop =
                        stops[index];

                        return Card(
                          margin:
                          const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: ListTile(

                            leading:
                            CircleAvatar(
                              backgroundColor:
                              Colors.green,
                              child: Text(
                                '${index + 1}',
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),

                            title: Text(
                              stop.stopName,
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              stop.stopTime,
                            ),

                            trailing: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [

                                IconButton(
                                  icon:
                                  const Icon(
                                    Icons.edit,
                                    color:
                                    Colors.blue,
                                  ),
                                  onPressed: () {
                                    editStop(
                                        stop);
                                  },
                                ),

                                IconButton(
                                  icon:
                                  const Icon(
                                    Icons.delete,
                                    color:
                                    Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteStop(
                                      stop
                                          .stopId,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}