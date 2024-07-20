import 'package:flutter/material.dart';

// import 'dart:developer';

import 'pages/home.dart';
import 'pages/raw.dart';
import 'pages/map.dart';

class TransportApp extends StatefulWidget {
  const TransportApp({super.key, required this.title});

  final String title;

  @override
  State<TransportApp> createState() => _TransportAppState();
}

class _TransportAppState extends State<TransportApp> {
  // Widget page = const NextDeparture();
  static int currentPageIndex = 0;
  static PageController pageController = PageController();

  List<Widget> pages = const [
    NextDeparture(),
    RawResponse(title: "Departures"),
    Map(),
  ];

  void changePage(int index) {
    setState(() {
      currentPageIndex = index;
    });
    // log("$currentPageIndex indexx");
    pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    // setState(() {
    //   switch (index) {
    //     case 0:
    //       page = const NextDeparture();
    //       break;
    //     case 1:
    //       page = const RawResponse(title: "Departures");
    //       break;
    //     default:
    //       page = const NextDeparture();
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: changePage,
          children: pages,
          ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.raw_on), label: "Raw"),
            NavigationDestination(icon: Icon(Icons.map_outlined), label: "Map"),
          ],
          onDestinationSelected: changePage,
          selectedIndex: currentPageIndex,
        ),
      ),
    );
  }
}