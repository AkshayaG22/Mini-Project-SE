
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:image_picker/image_picker.dart";

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

  final ImagePicker imagePicker = ImagePicker();
  final FixItApi api = FixItApi();

  String category = "Road";
  int severity = 3;
  bool submitting = false;

  XFile? selectedImage;

  Position? currentPosition;
  bool gettingLocation = false;
  String locationMessage = "Tap the location icon to detect your location";

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickPhoto() async {
    try {
      final XFile? photo = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null && mounted) {
        setState(() {
          selectedImage = photo;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not select photo: $e")),
      );
    }
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      gettingLocation = true;
      locationMessage = "Getting your location...";
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception("Enable location services on your device.");
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception("Location permission was denied.");
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          "Location permission is permanently denied. "
          "Check your device settings.",
        );
      }

      final position = await Geolocator.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        locationMessage =
            "${position.latitude.toStringAsFixed(5)}, "
            "${position.longitude.toStringAsFixed(5)}";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        currentPosition = null;
        locationMessage = "Location unavailable. Tap to try again.";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not get location: $e")),
      );
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

    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please detect your location before submitting."),
        ),
      );
      return;
    }

    setState(() => submitting = true);

    try {
      // First create the report in the database.
      final report = await api.createReport(
        title: titleController.text.trim(),
        category: category,
        severity: severity,
        description: descriptionController.text.trim(),
        location:
            "GPS: ${currentPosition!.latitude}, "
            "${currentPosition!.longitude}",
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );

      // If a photo was selected, upload it using the new report ID.
      if (selectedImage != null) {
        final dynamic rawId = report["report_id"] ?? report["id"];

        if (rawId == null) {
          throw Exception(
            "Report was created, but the server did not return its ID. "
            "The photo could not be uploaded.",
          );
        }

        final int reportId = rawId is int
            ? rawId
            : int.parse(rawId.toString());

        await api.uploadReportImage(
          reportId: reportId,
          image: selectedImage!,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            selectedImage == null
                ? "Report submitted successfully."
                : "Report and photo submitted successfully.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not complete submission: $e"),
          duration: const Duration(seconds: 5),
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

            OutlinedButton.icon(
              onPressed: submitting ? null : pickPhoto,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    selectedImage == null
                        ? "Add photo evidence"
                        : "Change selected photo",
                  ),
                ),
              ),
            ),

            if (selectedImage != null) ...[
              const SizedBox(height: 12),
              FutureBuilder<Uint8List>(
                future: selectedImage!.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Could not preview this photo.");
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      snapshot.data!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: submitting
                      ? null
                      : () {
                          setState(() {
                            selectedImage = null;
                          });
                        },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Remove photo"),
                ),
              ),
            ],

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
                      onSelected: submitting
                          ? null
                          : (_) {
                              setState(() => category = item);
                            },
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
              onChanged: submitting
                  ? null
                  : (value) {
                      setState(() => severity = value ?? 3);
                    },
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
                      onPressed: submitting ? null : getCurrentLocation,
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
