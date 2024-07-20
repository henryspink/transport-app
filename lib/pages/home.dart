import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../wrapper/wrapper.dart' as ptv;
import 'elements/stops.dart';

class NextDeparture extends StatefulWidget {
  const NextDeparture({super.key});
  @override
  State<NextDeparture> createState() => _NextDepartureState();

}
class _NextDepartureState extends State<NextDeparture> {
  ptv.Departure? nextDeparture;
  static int counter = 0;
  static String currentStation = "";
  static bool rerequest = false;
  // static ScrollController scrollController = ScrollController();
  static PanelController panelController = PanelController();

  @override
  void initState() {
    super.initState();
    currentStation = "laburnum";
  }

  final Stream<(ptv.Departure, ptv.Pattern)> updateNextDeparture = (() {
    late final StreamController<(ptv.Departure, ptv.Pattern)> controller;
    controller = StreamController<(ptv.Departure, ptv.Pattern)>(
      onListen: () async {
        log("inital");
        // final search = await ptv.request(ptv.search("cranbourne"), "");
        // log(search.toString());
        ptv.Departure? tempnext;
        ptv.Departure next;
        ptv.Departure old;
        ptv.Pattern pattern;
        tempnext = await ptv.GetNextDeparture.trainFromStation(currentStation);
        if (tempnext == null) {
          controller.addError("Getting next departure failed");
          return;
        }
        next = tempnext;
        pattern = await ptv.ServiceFromDeparture.getTrain(next);
        // scrollController.animateTo((pattern.stops.values.toList().indexOf(pattern.stops[next.stopId]!) * 100), duration: const Duration(seconds: 2), curve: Curves.ease);
        controller.add((next, pattern));
        // ignore: unused_local_variable
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (next.estimatedDeparture != null && ((next.estimatedDeparture!.isBefore(DateTime.now()) || next.estimatedDeparture!.difference(DateTime.now()).inSeconds <= 10) || rerequest)) {
            log("get next departure");
            log(currentStation);
            old = next;
            tempnext = await ptv.GetNextDeparture.trainFromStation(currentStation);
            log("hi");
            if (tempnext == null) {
              controller.addError("Getting next departure failed");
              return;
            }
            next = tempnext!;
            log("hii");
            pattern = await ptv.ServiceFromDeparture.getTrain(next);
            log("${old.runRef} ${next.runRef}");
            if ((old.runRef != next.runRef) || counter <= 1) {
              // new departure
              log("scrolling");
              // scrollController.animateTo((pattern.stops.values.toList().indexOf(pattern.stops[next.stopId]!) * 100), duration: const Duration(seconds: 2), curve: Curves.ease);
            }
            rerequest = false;
          }
          controller.add((next, pattern));
        });
      },
    );
    return controller.stream;
  }) ();

  Widget departureDetails(AsyncSnapshot snapshot) {
    ptv.Departure dep = snapshot.data!.$1;
    ptv.Pattern pattern = snapshot.data!.$2;
    DateTime? estimatedDeparture = dep.estimatedDeparture;
    DateTime? scheduledDeparture = dep.scheduledDeparture;
    String formatScheduledDeparture = ptv.displayTimeFormat.format(scheduledDeparture!);
    int platNum = dep.platformNumber;
    Duration expectedTimeTillDeparture;
    String estimatedIn;

    // if (estimatedDeparture == null) {
    //   return const Center(child: Text("No data"));
    // }

    counter++;
    if ((counter % 30) == 0) {
      rerequest = true;
    }
    
    if (estimatedDeparture != null) {
      expectedTimeTillDeparture = estimatedDeparture.difference(DateTime.now());
    } else {
      expectedTimeTillDeparture = scheduledDeparture.difference(DateTime.now());
    }

    if (expectedTimeTillDeparture.inMinutes <= 0) {
      estimatedIn = "${expectedTimeTillDeparture.inSeconds} sec${expectedTimeTillDeparture.inSeconds > 1 ? 's' : ''}";
    } else {
      NumberFormat secFormat = NumberFormat("00");
      estimatedIn = "${expectedTimeTillDeparture.inMinutes}.${secFormat.format(expectedTimeTillDeparture.inSeconds % (expectedTimeTillDeparture.inMinutes*60))}";
    }

    log("expectedTimeTillDeparture: ${expectedTimeTillDeparture.inSeconds}");
    log("${pattern.stops.values.toList().indexOf(pattern.stops[dep.stopId]!)} index");

    // return Column(
    //   children: [
    //     Text("Counter: $counter"),
    //     Text("Next Departure: $formatScheduledDeparture to ${pattern.runs.values.first.destinationName}"),
    //     Text("Estimated to depart in: $estimatedIn"),
    //     Text("Platform: $platNum, ${pattern.runs.values.first.expressStopCount} stop${pattern.runs.values.first.expressStopCount > 1 ? 's' : ''} skipped"),
    //     // SizedBox(
    //     //   height: 200,
    //     //   width: 200,
    //     //   child: stops(pattern, dep)
    //     // )
    //     ElevatedButton(
    //       onPressed: () => showModalBottomSheet(
    //         context: context,
    //         builder: (context) => stopsSheet(pattern, dep),
    //       ), 
    //       // DraggableScrollableSheet(
    //       //   builder: (context, scrollController) {
    //       //     return Container(
    //       //       child: stops(pattern, dep, scrollController),
    //       //     );
    //       //   },
    //       // ),
    //       child: const Text("test bottom sheet"))
    //   ]
    // );
    return SlidingUpPanel(
      controller: panelController,
      minHeight: 100,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {setState(() {rerequest = true;});},
            child: const Text("Reload")
          ),
          Text("Counter: $counter"),
          Text("Next Departure: $formatScheduledDeparture to ${pattern.runs.values.first.destinationName}"),
          Text("Estimated to depart in: $estimatedIn"),
          Text("Platform: $platNum, ${pattern.runs.values.first.expressStopCount} stop${pattern.runs.values.first.expressStopCount > 1 ? 's' : ''} skipped"),
        ]
      ),
      panelBuilder: (controller) => StopsSheet(
        controller: controller,
        panelController: panelController,
        pattern: pattern,
        departure: dep,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: updateNextDeparture, builder: (context, snapshot) { 
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
          return departureDetails(snapshot);
          } else {
            return const Center(child: Text("No data"));
          }
        case ConnectionState.done:
          return const Center(child: Text("Done (should never see this :D)"));
        }
      }
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
    return const NextDeparture();
  }
}