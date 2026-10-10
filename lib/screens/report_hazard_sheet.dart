import "package:flutter/material.dart";

// import "../services/fixit_api.dart";
import "../widgets/fixit_widgets.dart";

class ReportHazardSheet extends StatefulWidget {
  const ReportHazardSheet({super.key});

  @override
  State<ReportHazardSheet> createState() => _ReportHazardSheetState();
}

class _ReportHazardSheetState extends State<ReportHazardSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String category = "Road";
  int severity = 3;
  bool submitting = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please give the hazard a short title.")),
      );
      return;
    }
    setState(() => submitting = true);
    // ⚒️⚒️⚒️🛠️
    // try {
    //   await FixItApi().createReport(
    //     title: titleController.text.trim(),
    //     category: category,
    //     severity: severity,
    //     description: descriptionController.text.trim(),
    //     location: "Lakeview Road",
    //     latitude: 12.9716,
    //     longitude: 77.5946,
    //   );
    //   if (!mounted) return;
    //   Navigator.pop(context);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Report submitted successfully.")),
    //   );
    // } catch (_) {
    //   if (!mounted) return;
    //   setState(() => submitting = false);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Could not reach the FixIt server.")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        2,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("NEW REPORT", style: TextStyle(color: blue, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
            const Text("What did you spot?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text("Add photo evidence"),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Hazard title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ["Road", "Water", "Lighting", "Waste", "Trees", "Other"]
                  .map(
                    (item) => ChoiceChip(
                      label: Text(item),
                      selected: category == item,
                      onSelected: (_) => setState(() => category = item),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              value: severity,
              decoration: const InputDecoration(
                labelText: "Severity",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text("1 — Low")),
                DropdownMenuItem(value: 2, child: Text("2 — Moderate")),
                DropdownMenuItem(value: 3, child: Text("3 — High")),
                DropdownMenuItem(value: 4, child: Text("4 — Serious")),
                DropdownMenuItem(value: 5, child: Text("5 — Critical")),
              ],
              onChanged: (value) => setState(() => severity = value ?? 3),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(Icons.location_on_outlined)),
              title: Text("Lakeview Road", style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text("Current location · GPS accurate to 8m"),
              trailing: Icon(Icons.check_circle, color: Color(0xFF10B981)),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: submitting ? null : submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: submitting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text("Submit report", style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}
