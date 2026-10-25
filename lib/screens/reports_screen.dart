
import "package:flutter/material.dart";

import "../services/fixit_api.dart";
import "../widgets/fixit_widgets.dart";

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final FixItApi api = FixItApi();

  late Future<List<dynamic>> reportsFuture;

  @override
  void initState() {
    super.initState();
    reportsFuture = api.getReports();
  }

  Future<void> refreshReports() async {
    setState(() {
      reportsFuture = api.getReports();
    });

    await reportsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: reportsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Could not load reports."),
                  const SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        reportsFuture = api.getReports();
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final reports = snapshot.data ?? [];

        final activeCount = reports.where((report) {
          final status =
              (report["status"] ?? "Submitted").toString().toLowerCase();
          return status != "resolved" && status != "closed";
        }).length;

        final resolvedCount = reports.where((report) {
          final status =
              (report["status"] ?? "").toString().toLowerCase();
          return status == "resolved" || status == "closed";
        }).length;

        return RefreshIndicator(
          onRefresh: refreshReports,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
            children: [
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      value: "$activeCount",
                      label: "Active",
                      color: const Color(0xFFEFF6FF),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MetricCard(
                      value: "$resolvedCount",
                      label: "Resolved",
                      color: const Color(0xFFECFDF5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MetricCard(
                      value: "${reports.length}",
                      label: "Total",
                      color: const Color(0xFFF1F5F9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const SectionHeader(
                eyebrow: "",
                title: "Your activity",
                action: "All reports",
              ),
              const SizedBox(height: 12),

              if (reports.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text("No reports yet. Submit a hazard report to get started."),
                  ),
                )
              else
                ...reports.map((report) {
                  final title =
                      (report["title"] ?? "Untitled report").toString();
                  final category =
                      (report["category"] ?? "Other").toString();
                  final status =
                      (report["status"] ?? "Submitted").toString();
                  final severity = report["severity"] ?? 1;
                  final location =
                      (report["location"] ?? "Location unavailable").toString();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.report_problem_outlined),
                      ),
                      title: Text(title),
                      subtitle: Text(
                        "$category • $location\nSeverity: $severity",
                      ),
                      isThreeLine: true,
                      trailing: Text(
                        status,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
