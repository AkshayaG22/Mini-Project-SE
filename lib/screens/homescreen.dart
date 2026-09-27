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
        const SectionHeader(eyebrow: "AROUND YOU", title: "Live Hazard Map", action: "View map"),
        const SizedBox(height: 12),
        const HazardMap(height: 196),
        const SizedBox(height: 26),
        const SectionHeader(
          eyebrow: "YOUR IMPACT",
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
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF094DCA), Color(0xFF2A7AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3D0D57D5),
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            bottom: -60,
            child: Container(
              width: 220,
              height:220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12, width: 35),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "●  CITY STATUS: ACTIVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Spot it.\nWe'll help fix it.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    height: 1.04,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  width: 260,
                  child: Text(
                    "Report civic hazards and follow every step to resolution.",
                    style: TextStyle(
                      color: Color(0xFFDBEAFE),
                      fontSize: 13,
                      height: 1.45,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

