import "package:flutter/material.dart";

import "../widgets/fixit_widgets.dart";

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        const Herocard(),
        const SizedBox(height: 24),
        const SectionHeader(eyebrow: "", title: "Live Hazard Map", action: "View map"),
        const SizedBox(height: 12),
        const HazardMap(height: 196),
        const SizedBox(height: 26),
        const SectionHeader(
          eyebrow: "",
          title: "Recent reports",
          action: "See all",
        ),
        const SizedBox(height: 12),
        const ImpactCard(),
      ],
    );
  }
}

class Herocard extends StatelessWidget {
  const Herocard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 218,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E5FD8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "",
                  style: TextStyle(
                    color: Color(0xFFBFD6F7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Spot it.\nWe'll help fix it.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  width: 260,
                  child: Text(
                    "Report civic hazards and follow every step to resolution.",
                    style: TextStyle(
                      color: Color(0xFFD6E4F9),
                      fontSize: 14,
                      height: 1.4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}