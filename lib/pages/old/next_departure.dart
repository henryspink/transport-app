import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/ptv/content/content.dart';
import 'package:transport_app/ptv/util/datetime.dart';

import '../../ptv/wrapper.dart' as ptv;

class NextDeparture extends StatefulWidget {
  const NextDeparture({super.key});
  @override
  State<NextDeparture> createState() => _NextDepartureState();

}
class _NextDepartureState extends State<NextDeparture> {
  ptv.Departure? nextDeparture;
  int counter = 0;
  static String currentStation = "";
  static bool rerequest = false;
  static ScrollController scrollController = ScrollController();

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
              // return;
            }
            next = tempnext!;
            log("hii");
            pattern = await ptv.ServiceFromDeparture.getTrain(next);
            log("${old.runRef} ${next.runRef}");
            if (old.runRef != next.runRef) {
              // new departure
              log("scrolling");
              scrollController.animateTo((pattern.stops.values.toList().indexOf(pattern.stops[next.stopId]!) * 50), duration: const Duration(seconds: 2), curve: Curves.ease);
            }
            rerequest = false;
          }
          controller.add((next, pattern));
        });
      },
    );
    return controller.stream;
  }) ();

  ListView stops(pattern, dep) {
    // ScrollController controller = ScrollController(initialScrollOffset: (pattern.stops.values.toList().indexOf(pattern.stops[dep.stopId]!) * 50).toDouble());
    return ListView.builder(
      controller: scrollController,
      itemCount: pattern.stops.length,
      itemBuilder: (context, index) {
        ThemeData theme = Theme.of(context);
        // time stuff for each stop
        List<Widget> time;
        PatternDeparture patdep = pattern.departures[index];
        if ((patdep.estimatedDeparture != null) && (patdep.estimatedDeparture!.toString() != patdep.scheduledDeparture.toString())) { // the train is late (or early idk)
          time = [
            Text(
              displayTimeFormat.format(patdep.scheduledDeparture!),
              style: const TextStyle(decoration: TextDecoration.lineThrough)
            ),
            const SizedBox(width: 10),
            Text(
              displayTimeFormat.format(patdep.estimatedDeparture!),
              style: const TextStyle(color: Colors.red)
            ),
          ];
        } else { // the train is on time or estimated time is not availiable
          time = [Text(displayTimeFormat.format(patdep.scheduledDeparture!)),];
        }
        Widget times = Row(children: time,);
        return SizedBox(
          height: 50,
          width: 50,
          child: ListTile(
            textColor: pattern.stops.values.elementAt(index).stopId == dep.stopId ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            title: Text(pattern.stops.values.elementAt(index).stopName),
            subtitle: times
          ),
        );
      }
    );
  }

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

    return Column(
      children: [
        Text("Counter: $counter"),
        Text("Next Departure: $formatScheduledDeparture to ${pattern.runs.values.first.destinationName}"),
        Text("Estimated to depart in: $estimatedIn"),
        Text("Platform: $platNum, ${pattern.runs.values.first.expressStopCount} stop${pattern.runs.values.first.expressStopCount > 1 ? 's' : ''} skipped"),
        SizedBox(
          height: 200,
          width: 200,
          child: stops(pattern, dep)
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {setState(() {rerequest = true;});},
            child: const Text("Reload")
          ),
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
                return Center(child: departureDetails(snapshot));
                } else {
                  return const Center(child: Text("No data"));
                }
              case ConnectionState.done:
                return const Center(child: Text("Done (should never see this :D)"));
              }
            }
          )
        ]
      ),
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