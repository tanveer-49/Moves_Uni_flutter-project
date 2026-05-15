import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/bus_service.dart';
import '../../models/bus_model.dart';

class ManageBusesScreen extends StatefulWidget {
  const ManageBusesScreen({super.key});

  @override
  State<ManageBusesScreen> createState() =>
      _ManageBusesScreenState();
}

class _ManageBusesScreenState
    extends State<ManageBusesScreen> {
  final BusService _busService = BusService();

  final TextEditingController busCodeController =
  TextEditingController();

  final TextEditingController plateController =
  TextEditingController();

  final TextEditingController driverController =
  TextEditingController();

  bool isLoading = false;

  String? editingBusId;

  /// ADD OR UPDATE BUS
  Future<void> saveBus() async {
    if (busCodeController.text.trim().isEmpty ||
        plateController.text.trim().isEmpty ||
        driverController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final bus = BusModel(
        busId: editingBusId ?? const Uuid().v4(),
        busCode: busCodeController.text.trim(),
        plateNumber: plateController.text.trim(),
        driverName: driverController.text.trim(),
      );

      if (editingBusId == null) {
        await _busService.addBus(bus);
      } else {
        await _busService.updateBus(bus);
      }

      clearFields();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingBusId == null
                ? 'Bus Added Successfully'
                : 'Bus Updated Successfully',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// CLEAR FORM
  void clearFields() {
    busCodeController.clear();
    plateController.clear();
    driverController.clear();

    editingBusId = null;
  }

  /// EDIT BUS
  void editBus(BusModel bus) {
    editingBusId = bus.busId;

    busCodeController.text = bus.busCode;
    plateController.text = bus.plateNumber;
    driverController.text = bus.driverName;

    setState(() {});
  }

  /// DELETE BUS
  Future<void> deleteBus(String busId) async {
    try {
      await _busService.deleteBus(busId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bus Deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text('Manage Buses'),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// LEFT SIDE FORM
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      editingBusId == null
                          ? 'Add New Bus'
                          : 'Update Bus',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: busCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Bus Code',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: plateController,
                      decoration: const InputDecoration(
                        labelText: 'Plate Number',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: driverController,
                      decoration: const InputDecoration(
                        labelText: 'Driver Name',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                        isLoading ? null : saveBus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          editingBusId == null
                              ? 'Add Bus'
                              : 'Update Bus',
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: StreamBuilder<List<BusModel>>(
                  stream: _busService.getBuses(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    }

                    final buses = snapshot.data ?? [];

                    if (buses.isEmpty) {
                      return const Center(
                        child: Text('No buses found'),
                      );
                    }

                    return ListView.builder(
                      itemCount: buses.length,
                      itemBuilder: (context, index) {

                        final bus = buses[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: ListTile(

                            title: Text(
                              bus.busCode,
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  'Plate: ${bus.plateNumber}',
                                ),

                                Text(
                                  'Driver: ${bus.driverName}',
                                ),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [

                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    editBus(bus);
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteBus(bus.busId);
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