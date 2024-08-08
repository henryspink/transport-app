import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'pages/nav_pages/home.dart';
import 'pages/nav_pages/routes.dart';
import 'pages/nav_pages/search.dart';
import 'pages/nav_pages/disruptions.dart';
import 'pages/nav_pages/more.dart';


// import 'pages/old/raw.dart';
// import 'pages/map/map.dart';
// import 'pages/auth/login.dart';

class TransportApp extends StatefulWidget {
  const TransportApp({super.key, required this.title});

  final String title;

  @override
  State<TransportApp> createState() => _TransportAppState();
}

class _TransportAppState extends State<TransportApp> {
  static int currentPageIndex = 0;
  static PageController pageController = PageController();

  Widget navBar() {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10, top: 10),
        child: GNav(
          gap: 5,
          selectedIndex: currentPageIndex,
          // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          iconSize: 30,
          backgroundColor: theme.colorScheme.primaryContainer,
          tabBackgroundColor: theme.colorScheme.primary,
          hoverColor: Colors.grey[800]!,
          tabBorderRadius: 100,
          onTabChange: (int index) {
            setState(() {
              currentPageIndex = index;
            });
            pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          tabs: [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
              padding: const EdgeInsets.all(8),
              textColor: theme.colorScheme.onPrimary,
              iconActiveColor: theme.colorScheme.onPrimary,
            ),
            GButton(
              icon: Icons.route_outlined,
              text: 'Routes',
              padding: const EdgeInsets.all(8),
              textColor: theme.colorScheme.onPrimary,
              iconActiveColor: theme.colorScheme.onPrimary,
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
              padding: const EdgeInsets.all(8),
              textColor: theme.colorScheme.onPrimary,
              iconActiveColor: theme.colorScheme.onPrimary,
            ),
            GButton(
              icon: Icons.notifications_outlined,
              text: 'Disruptions',
              leading: Badge(
                label: const Text("5"),
                child: Icon(
                  Icons.notifications_outlined,
                  color: currentPageIndex == 3 ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                )
              ),
              padding: const EdgeInsets.all(8),
              textColor: theme.colorScheme.onPrimary,
              iconActiveColor: theme.colorScheme.onPrimary,
            ),
            GButton(
              icon: Icons.menu,
              text: 'More',
              padding: const EdgeInsets.all(8),
              textColor: theme.colorScheme.onPrimary,
              iconActiveColor: theme.colorScheme.onPrimary,
            ),
          ]
        ),
      ),
    );
  }

  List<Widget> pages = const [
    Home(),
    Routes(),
    Search(),
    Disruptions(),
    More(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: pages,
        ),
      bottomNavigationBar: navBar(),
    );
  }
}