import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../wrapper/wrapper.dart' as ptv;

class NextDeparture extends StatefulWidget {
  const NextDeparture({super.key});
  @override
  State<NextDeparture> createState() => _NextDepartureState();

}
class _NextDepartureState extends State<NextDeparture> {
  ptv.Departure? nextDeparture;
  int counter = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   nextDeparture = ptv.GetNextDeparture.trainFromStation("laburnum");
  // }

  final Stream<(ptv.Departure, ptv.Pattern)> updateNextDeparture = (() {
    late final StreamController<(ptv.Departure, ptv.Pattern)> controller;
    controller = StreamController<(ptv.Departure, ptv.Pattern)>(
      onListen: () async {
        log("inital");
        ptv.Departure next = await ptv.GetNextDeparture.trainFromStation("laburnum");
        ptv.Pattern pattern = await ptv.ServiceFromDeparture.getTrain(next);
        controller.add((next, pattern));
        // ignore: unused_local_variable
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (next.estimatedDeparture.isBefore(DateTime.now()) || next.estimatedDeparture.difference(DateTime.now()).inSeconds <= 10) {
            log("get next departure");
            next = await ptv.GetNextDeparture.trainFromStation("laburnum");
            pattern = await ptv.ServiceFromDeparture.getTrain(next);
          }
          controller.add((next, pattern));
        });
      },
    );
    return controller.stream;
  }) ();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(stream: updateNextDeparture, builder: (context, snapshot) { 
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text("No data"));
            case ConnectionState.waiting:
              log("waiting");
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (snapshot.hasData) {
                ptv.Departure dep = snapshot.data!.$1;
                ptv.Pattern pattern = snapshot.data!.$2;
                DateTime estimatedDeparture = dep.estimatedDeparture;
                DateTime scheduledDeparture = dep.scheduledDeparture;
                String formatScheduledDeparture = ptv.displayTimeFormat.format(scheduledDeparture);
                Duration expectedTimeTillDeparture = estimatedDeparture.difference(DateTime.now());
                // bool atPlatform = dep.atPlatform;
                int platNum = dep.platformNumber;
                counter++;
                log("expectedTimeTillDeparture: ${expectedTimeTillDeparture.inSeconds}");
                String estimatedIn;
                if (expectedTimeTillDeparture.inMinutes <= 0) {
                  estimatedIn = "${expectedTimeTillDeparture.inSeconds} sec${expectedTimeTillDeparture.inSeconds > 1 ? 's' : ''}";
                } else {
                  estimatedIn = "${expectedTimeTillDeparture.inMinutes} min${expectedTimeTillDeparture.inMinutes > 1 ? 's' : ''}";
                }
                log("hi");
                return SingleChildScrollView(child: 
                  Column(
                    children: [
                    Text("Counter: $counter"),
                    Text("Next Departure: $formatScheduledDeparture to ${pattern.run.destinationName}"),
                    Text("Estimated to depart in: $estimatedIn"),
                    Text("Platform: $platNum, ${pattern.run.expressStopCount} stops skipped"),
                    ]
                  )
                );
              } else {
                return const Center(child: Text("No data"));
              }
            case ConnectionState.done:
              return const Center(child: Text("Done (should never see this :D)"));
            }
          }
        ),
      ],
    );
  }
}

class TestDetails extends StatefulWidget {
  const TestDetails({super.key, required this.title});
  final String title;
  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NextDeparture()
      ],
    );
  }
}