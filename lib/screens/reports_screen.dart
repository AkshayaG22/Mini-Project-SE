import "package:flutter/material.dart";

// import "../models/hazard_report.dart";
import "../widgets/fixit_widgets.dart";

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        const Row(
          children: [
            Expanded(child: MetricCard(value: "2", label: "Active", color: Color(0xFFEFF6FF))),
            SizedBox(width: 8),
            Expanded(child: MetricCard(value: "3", label: "Resolved", color: Color(0xFFECFDF5))),
            SizedBox(width: 8),
            Expanded(child: MetricCard(value: "5", label: "Total", color: Color(0xFFF1F5F9))),
          ],
        ),
        const SizedBox(height: 26),
        const SectionHeader(eyebrow: "", title: "Your activity", action: "All reports"),
        const SizedBox(height: 12),
        // ...sampleReports.map(
        //   (report) => Padding(
        //     padding: const EdgeInsets.only(bottom: 12),
        //     child: ReportCard(report: report),
        //   ),
        // ),
        // ReportCard(
        //   report: HazardReport(
        //     id: "FX-1984",
        //     title: "Broken streetlight",
        //     category: "Lighting",
        //     severity: 2,
        //     location: "Oak Avenue",
        //     status: HazardStatus.resolved,
        //     reportedAt: DateTime(2025, 5, 18),
        //   ),
        //),
      ],
    );
  }
}
