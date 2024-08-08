import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../ptv/wrapper.dart' as ptv;
import '../elements/stops.dart';
import '../map/map.dart';
import '../auth/profile.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();

}
class _HomeState extends State<Home> {
  ptv.Departure? nextDeparture;
  static int counter = 0;
  static String currentStation = "";
  static bool rerequest = false;
  // static ScrollController scrollController = ScrollController();
  static PanelController panelController = PanelController();
  static Timer? timer;

  @override
  void initState() {
    super.initState();
    currentStation = "laburnum";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final Stream<(ptv.Departure, ptv.Pattern)> updateNextDeparture = (() {
    late final StreamController<(ptv.Departure, ptv.Pattern)> controller;
    controller = StreamController<(ptv.Departure, ptv.Pattern)>(
      onListen: () async {
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
        timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          counter++;
          if ((counter % 30) == 0) {
            rerequest = true;
          }
          
          if (next.estimatedDeparture != null && ((next.estimatedDeparture!.isBefore(DateTime.now()) || next.estimatedDeparture!.difference(DateTime.now()).inSeconds <= 10) || rerequest)) {
            old = next;
            tempnext = await ptv.GetNextDeparture.trainFromStation(currentStation);
            if (tempnext == null) {
              controller.addError("Getting next departure failed");
              log("eror");
              return;
            }
            next = tempnext!;
            pattern = await ptv.ServiceFromDeparture.getTrain(next);
            if ((old.runRef != next.runRef) || counter <= 1) {
              // scrollController.animateTo((pattern.stops.values.toList().indexOf(pattern.stops[next.stopId]!) * 100), duration: const Duration(seconds: 2), curve: Curves.ease);
            }
            rerequest = false;
            if (next.estimatedDeparture!.difference(DateTime.now()).inSeconds < 0) {
              log("neg - ${next.estimatedDeparture!.difference(DateTime.now()).inSeconds}");
              rerequest = true;
            }
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

    return SlidingUpPanel(
      controller: panelController,
      minHeight: 100,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {setState(() {rerequest = true;});log('reload');},
                child: const Text("Reload")
              ),
              ElevatedButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Map()));},
                child: const Text("Map")
              )
            ],
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
    ThemeData theme = Theme.of(context);
    Widget avatar = Icon(
      Icons.person,
      color: theme.colorScheme.onPrimary,
      size: 40,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transport App",
              style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              "hi",
              style: TextStyle(color: Colors.grey[300]),
            )
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              radius: 35,
              child: avatar
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder(stream: updateNextDeparture, builder: (context, snapshot) { 
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(child: Text("No data"));
          case ConnectionState.waiting:
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
    return const Home();
  }
}