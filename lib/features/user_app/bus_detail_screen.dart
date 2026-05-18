import 'package:flutter/material.dart';

import '../../core/services/route_service.dart';
import '../../models/bus_model.dart';
import '../../models/route_stop_model.dart';

class BusDetailScreen extends StatelessWidget {

  final BusModel bus;

  const BusDetailScreen({
    super.key,
    required this.bus,
  });

  @override
  Widget build(BuildContext context) {

    final RouteService routeService =
    RouteService();

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F7FA),

      appBar: AppBar(
        title: Text(bus.busCode),
        backgroundColor:
        Colors.green,
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// BUS INFO CARD
            Container(

              padding:
              const EdgeInsets.all(
                20,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    bus.busCode,

                    style:
                    const TextStyle(
                      fontSize: 28,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.confirmation_number,
                        color:
                        Colors.green,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        bus.plateNumber,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.person,
                        color:
                        Colors.green,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        bus.driverName,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            /// MORNING ROUTE
            buildRouteSection(
              title: 'Morning Route',
              stream:
              routeService.getStops(
                busId: bus.busId,
                routeType: 'morning',
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            /// EVENING ROUTE
            buildRouteSection(
              title: 'Evening Route',
              stream:
              routeService.getStops(
                busId: bus.busId,
                routeType: 'evening',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ROUTE SECTION
  Widget buildRouteSection({
    required String title,
    required Stream<List<RouteStopModel>>
    stream,
  }) {

    return Container(

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style:
            const TextStyle(
              fontSize: 22,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          StreamBuilder<
              List<RouteStopModel>>(
            stream: stream,

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

              final stops =
                  snapshot.data ?? [];

              if (stops.isEmpty) {

                return const Text(
                  'No route available',
                );
              }

              return Column(

                children:
                List.generate(
                  stops.length,

                      (index) {

                    final stop =
                    stops[index];

                    final isLast =
                        index ==
                            stops.length -
                                1;

                    return Row(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        /// TIMELINE
                        Column(
                          children: [

                            Container(
                              width: 16,
                              height: 16,

                              decoration:
                              const BoxDecoration(
                                color:
                                Colors.green,
                                shape:
                                BoxShape.circle,
                              ),
                            ),

                            if (!isLast)

                              Container(
                                width: 2,
                                height: 50,
                                color:
                                Colors.green,
                              ),
                          ],
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        /// CONTENT
                        Expanded(
                          child: Container(

                            margin:
                            const EdgeInsets.only(
                              bottom: 20,
                            ),

                            padding:
                            const EdgeInsets.all(
                              16,
                            ),

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.green
                                  .withOpacity(
                                0.05,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),

                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                              children: [

                                Text(
                                  stop.stopName,

                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize:
                                    16,
                                  ),
                                ),

                                Text(
                                  stop.stopTime,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}