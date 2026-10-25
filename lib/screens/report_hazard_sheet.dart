
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "../services/fixit_api.dart";
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

  // 📍 Store the user's actual location
  Position? currentPosition;
  bool gettingLocation = false;
  String locationMessage = "Location not detected yet";

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // 📍 Get the user's current location from the browser
  Future<void> getCurrentLocation() async {
    setState(() {
      gettingLocation = true;
      locationMessage = "Getting your location...";
    });

    try {
      final position = await Geolocator.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        locationMessage =
            "Coordinates: ${position.latitude.toStringAsFixed(5)}, "
            "${position.longitude.toStringAsFixed(5)}";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        currentPosition = null;
        locationMessage =
            "Could not get location. Allow location access in Chrome.";
      });
    } finally {
      if (mounted) {
        setState(() => gettingLocation = false);
      }
    }
  }

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please give the hazard a short title."),
        ),
      );
      return;
    }

    // 📍 Make sure the user has detected their location first
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please detect your location before submitting."),
        ),
      );
      return;
    }

    setState(() => submitting = true);

    // 🛠️ Send the report to the FixIt backend
    try {
      await FixItApi().createReport(
        title: titleController.text.trim(),
        category: category,
        severity: severity,
        description: descriptionController.text.trim(),
        location: locationMessage,
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Report submitted successfully."),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not submit report: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
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
            const Text(
              "NEW REPORT",
              style: TextStyle(
                color: blue,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            const Text(
              "What did you spot?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),

            // ⚒️ Photo upload will be implemented separately
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

            // 📍 Display real coordinates instead of a hardcoded road name
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.location_on_outlined),
              ),
              title: const Text(
                "Report location",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(locationMessage),
              trailing: gettingLocation
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: getCurrentLocation,
                      tooltip: "Detect my location",
                    ),
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: submitting ? null : submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Submit report",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
