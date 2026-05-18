import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/bus_model.dart';
import 'bus_detail_screen.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() =>
      _UserHomeState();
}

class _UserHomeState
    extends State<UserHome> {

  final TextEditingController
  searchController =
  TextEditingController();

  String searchText = '';

  /// GET BUSES
  Stream<List<BusModel>> getBuses() {

    return FirebaseFirestore.instance
        .collection('buses')
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return BusModel.fromMap(
          doc.data(),
        );

      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F7FA),

      appBar: AppBar(
        title:
        const Text(
          'University Buses',
        ),
        backgroundColor:
        Colors.green,
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(20),

        child: Column(
          children: [

            /// SEARCH
            TextField(

              controller:
              searchController,

              onChanged: (value) {

                setState(() {
                  searchText =
                      value.toLowerCase();
                });
              },

              decoration:
              InputDecoration(

                hintText:
                'Search by Bus Code or Plate Number',

                prefixIcon:
                const Icon(Icons.search),

                filled: true,

                fillColor:
                Colors.white,

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// BUS LIST
            Expanded(
              child:
              StreamBuilder<
                  List<BusModel>>(
                stream: getBuses(),

                builder:
                    (context, snapshot) {

                  /// LOADING
                  if (snapshot
                      .connectionState ==
                      ConnectionState
                          .waiting) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  /// ERROR
                  if (snapshot.hasError) {

                    return Center(
                      child: Text(
                        snapshot.error
                            .toString(),
                      ),
                    );
                  }

                  final buses =
                      snapshot.data ?? [];

                  /// FILTER SEARCH
                  final filteredBuses =
                  buses.where((bus) {

                    return bus.busCode
                        .toLowerCase()
                        .contains(
                      searchText,
                    ) ||
                        bus.plateNumber
                            .toLowerCase()
                            .contains(
                          searchText,
                        );
                  }).toList();

                  /// EMPTY STATE
                  if (filteredBuses
                      .isEmpty) {

                    return const Center(
                      child: Text(
                        'No buses found',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(

                    itemCount:
                    filteredBuses.length,

                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount:
                      MediaQuery.of(context).size.width > 900
                          ? 4
                          : MediaQuery.of(context).size.width > 600
                          ? 3
                          : 2,

                      crossAxisSpacing: 20,

                      mainAxisSpacing: 20,

                      childAspectRatio: 0.78,
                    ),

                    itemBuilder:
                        (context, index) {

                      final bus =
                      filteredBuses[
                      index];

                      return InkWell(

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  BusDetailScreen(
                                    bus: bus,
                                  ),
                            ),
                          );
                        },

                        child: Container(

                          padding:
                          const EdgeInsets.all(
                            20,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.white,

                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),

                            boxShadow: [

                              BoxShadow(
                                color: Colors
                                    .grey
                                    .withOpacity(
                                    0.1),

                                blurRadius:
                                10,

                                offset:
                                const Offset(
                                  0,
                                  5,
                                ),
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Container(
                                padding:
                                const EdgeInsets.all(
                                  12,
                                ),

                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors.green
                                      .withOpacity(
                                    0.1,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                                ),

                                child: const Icon(
                                  Icons.directions_bus,
                                  color:
                                  Colors.green,
                                  size: 30,
                                ),
                              ),

                              const Spacer(),

                              Text(
                                bus.busCode,

                                style:
                                const TextStyle(
                                  fontSize:
                                  20,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                'Plate: ${bus.plateNumber}',
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                'Driver: ${bus.driverName}',
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
          ],
        ),
      ),
    );
  }
}