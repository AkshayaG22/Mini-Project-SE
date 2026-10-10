import "package:flutter/material.dart";

import "../widgets/fixit_widgets.dart";

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        Stack(
          children: [
            const HazardMap(height: 430, expanded: true),
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: SearchBar(
                hintText: "Search a street or neighborhood",
                leading: const Icon(Icons.search),
                elevation: const MaterialStatePropertyAll(5),
                backgroundColor: const MaterialStatePropertyAll(Colors.white),
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: MapStats(),
            ),
          ],
        ),
        const SizedBox(height: 17),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(label: Text("All hazards"), selected: true, onSelected: null),
              SizedBox(width: 8),
              Chip(label: Text("Roads")),
              SizedBox(width: 8),
              Chip(label: Text("Water")),
              SizedBox(width: 8),
              Chip(label: Text("Lighting")),
              SizedBox(width: 8),
              Chip(label: Text("Waste")),
            ],
          ),
        ),
      ],
    );
  }
}
