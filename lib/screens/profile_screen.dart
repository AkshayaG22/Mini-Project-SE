import "package:flutter/material.dart";

import "../widgets/fixit_widgets.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: const Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: blue,
                  child: Text("AK", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                ),
                SizedBox(height: 14),
                Text("Aarav Kumar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text("Civic contributor since 2024", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProfileMetric(value: "5", label: "Reports"),
                    ProfileMetric(value: "3", label: "Resolved"),
                    ProfileMetric(value: "86", label: "Points"),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(leading: Icon(Icons.groups_outlined), title: Text("Community contributions"), trailing: Icon(Icons.chevron_right)),
              Divider(height: 1),
              ListTile(leading: Icon(Icons.notifications_none), title: Text("Notification preferences"), trailing: Icon(Icons.chevron_right)),
              Divider(height: 1),
              ListTile(leading: Icon(Icons.shield_outlined), title: Text("Privacy and safety"), trailing: Icon(Icons.chevron_right)),
            ],
          ),
        ),
      ],
    );
  }
}
