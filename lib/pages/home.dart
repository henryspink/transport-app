import 'dart:async';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:transport_app/wrapper/content/content.dart';

// import '../wrapper/util/urls.dart' as urls;
import '../wrapper/wrapper.dart' as ptv;
// import '../wrapper/util/request.dart' as req;

class NextDeparture extends StatefulWidget {
  const NextDeparture({super.key});
  @override
  State<NextDeparture> createState() => _NextDepartureState();

}
class _NextDepartureState extends State<NextDeparture> {
  late Future<ptv.Departure> nextDeparture;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    // nextDeparture = ptv.GetNextDeparture.trainFromStation("laburnum");
  }

  final Stream<Departure> updateNextDeparture = (() {
    late final StreamController<Departure> controller;
    controller = StreamController<Departure>(
      onListen: () async {
        log("inital");
        Departure next = await ptv.GetNextDeparture.trainFromStation("laburnum");
        controller.add(next);
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          log("update departure");
          if (next.estimatedDeparture.isBefore(DateTime.now()) || next.estimatedDeparture.difference(DateTime.now()).inSeconds <= 10) {
            log("get next departure");
            next = await ptv.GetNextDeparture.trainFromStation("laburnum");
          }
          controller.add(next);
        });
        // log("canceled");
        // timer.cancel();
        // if (next.estimatedDeparture.isBefore(DateTime.now())) {
        //   timer.cancel();
        //   await controller.close();
        // }
      },
    );
    return controller.stream;
  }) ();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: updateNextDeparture, builder: (context, snapshot) { 
      // if (snapshot.connectionState == ConnectionState.done) {
      //   if (snapshot.hasError) {
      //     return Center(child: Text("Error: ${snapshot.error}"));
      //   }
      //   if (snapshot.hasData) {
      //     final expectedTimeTillDeparture = snapshot.data!.estimatedDeparture.difference(DateTime.now());
      //     final atPlatform = snapshot.data!.atPlatform;
      //     log("expectedTimeTillDeparture: ${expectedTimeTillDeparture.inSeconds}");
      //     return SingleChildScrollView(child: Text("${snapshot.data!.estimatedDeparture.toString()}\n${expectedTimeTillDeparture.inMinutes} min${expectedTimeTillDeparture.inMinutes > 1 ? 's' : ''}\n$atPlatform",));
      //   } else {
      //     return const Center(child: Text("No data"));
      //   }
      // } else {
      //   return const Center(child: CircularProgressIndicator());
      // }
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
            Departure data = snapshot.data!;
            DateTime estimatedDeparture = data.estimatedDeparture;
            DateTime scheduledDeparture = data.scheduledDeparture;
            String formatScheduledDeparture = DateFormat("HH:mm").format(scheduledDeparture);
            Duration expectedTimeTillDeparture = estimatedDeparture.difference(DateTime.now());
            bool atPlatform = data.atPlatform;
            int platNum = data.platformNumber;
            counter++;
            log("expectedTimeTillDeparture: ${expectedTimeTillDeparture.inSeconds}");
            String estimatedIn;
            if (expectedTimeTillDeparture.inMinutes <= 0) {
              estimatedIn = "${expectedTimeTillDeparture.inSeconds} sec${expectedTimeTillDeparture.inSeconds > 1 ? 's' : ''}";
            } else {
              estimatedIn = "${expectedTimeTillDeparture.inMinutes} min${expectedTimeTillDeparture.inMinutes > 1 ? 's' : ''}";
            }
            return SingleChildScrollView(child: Column(children: [
              Text("Counter: $counter"),
              Text("Next Departure: $formatScheduledDeparture to {ins later}"),
              Text("Estimated to depart in: $estimatedIn"),
              Text("Platform: $platNum"),
              // Text(text)
              ]));
          } else {
            return const Center(child: Text("No data"));
          }
        case ConnectionState.done:
          return const Center(child: Text("No data"));
      }
    });
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