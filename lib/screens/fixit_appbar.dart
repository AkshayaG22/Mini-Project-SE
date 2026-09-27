import "package:flutter/material.dart";

import "../widgets/fixit_widgets.dart";

//import others when doing the other buttons!
import 'homescreen.dart';

class FixItShell extends StatefulWidget {
  const FixItShell({super.key});

  @override
  State<FixItShell> createState() => _FixItShellState();
}

class _FixItShellState extends State<FixItShell> {
  int currentIndex = 0;

  static const titles = [
    ("Good morning, {User name}", ""),
    ("Explore your city", "See what is happening nearby."),
    ("My reports", "Track progress and outcomes."),
    ("Your profile", "Impact starts with participation."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvas,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        toolbarHeight: 86,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                BrandMark(),
                SizedBox(width: 7),
                Text(
                  "FIXIT",
                  style: TextStyle(
                    color: blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              titles[currentIndex].$1,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              titles[currentIndex].$2,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          Homescreen(),
          // ExploreScreen(),
          // ReportsScreen(),
          // ProfileScreen(),
        ],
      ),
      //for the report button! [bug]
      
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showModalBottomSheet<void>(
      //     context: context,
      //     isScrollControlled: true,
      //     showDragHandle: true,
      //     backgroundColor: canvas,
      //     builder: (_) => const ReportHazardSheet(),
      //   ),
      //   backgroundColor: blue,
      //   foregroundColor: Colors.white,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      //   child: const Icon(Icons.add_rounded, size: 30),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 76,
        color: Colors.white,
        notchMargin: 9,
        shape: const CircularNotchedRectangle(),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: "Home",
              selected: currentIndex == 0,
              onTap: () => setState(() => currentIndex = 0),
            ),

            NavItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map_rounded,
              label: "Explore",
              selected: currentIndex == 1,
              onTap: () => setState(() => currentIndex = 1),
            ),

            const SizedBox(width: 54),

            NavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description_rounded,
              label: "Reports",
              selected: currentIndex == 2,
              onTap: () => setState(() => currentIndex = 2),
            ),

            NavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: "Profile",
              selected: currentIndex == 3,
              onTap: () => setState(() => currentIndex = 3),
            ),

          ],
        ),
      ),
    );
  }
}
