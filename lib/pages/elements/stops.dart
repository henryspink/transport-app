import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../wrapper/wrapper.dart' as ptv;

class StopsSheet extends StatelessWidget {
  final ScrollController controller;
  final ptv.Pattern pattern;
  final ptv.Departure departure;
  final PanelController panelController;
  const StopsSheet({
    super.key,
    required this.controller,
    required this.panelController,
    required this.pattern,
    required this.departure,
  });

  void togglePanel() => panelController.isPanelOpen
    ? panelController.close()
    : panelController.open();

  @override
  Widget build(BuildContext context) => ListView.builder(
    controller: controller,
    itemCount: pattern.stops.length,
    itemBuilder: (context, index) {
      if (index == 0) {
        return SizedBox(
          height: 100,
          width: 100,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: togglePanel,
                child: Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Stops", style: TextStyle(fontSize: 25),),
              const SizedBox(height: 10,),
            ],
          )
        );
      }
      index -= 1;

      ThemeData theme = Theme.of(context);
      // time stuff for each stop
      List<Widget> time;
      ptv.PatternDeparture patdep = pattern.departures[index];
      if ((patdep.estimatedDeparture != null) && (patdep.estimatedDeparture!.toString() != patdep.scheduledDeparture.toString())) { // the train is late (or early idk)
        time = [
          Text(
            ptv.displayTimeFormat.format(patdep.scheduledDeparture!),
            style: const TextStyle(decoration: TextDecoration.lineThrough)
          ),
          const SizedBox(width: 10),
          Text(
            ptv.displayTimeFormat.format(patdep.estimatedDeparture!),
            style: const TextStyle(color: Colors.red)
          ),
        ];
      } else { // the train is on time or estimated time is not availiable
        time = [Text(ptv.displayTimeFormat.format(patdep.scheduledDeparture!)),];
      }
      Widget times = Row(children: time,);
      return SizedBox(
        height: 100,
        width: 100,
        child: Card(
          child: ListTile(
            textColor: pattern.stops.values.elementAt(index).stopId == departure.stopId ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            title: Text(pattern.stops.values.elementAt(index).stopName, style: const TextStyle(fontSize: 20),),
            subtitle: times
          ),
        ),
      );
    }
  );
}