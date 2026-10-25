
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FixItApi {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<Map<String, dynamic>> createReport({
    required String title,
    required String category,
    required int severity,
    required String description,
    required String location,
    double? latitude,
    double? longitude,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'category': category,
        'severity': severity,
        'description': description,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Report submission failed: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reports'),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not load reports: ${response.body}');
    }

    return jsonDecode(response.body) as List<dynamic>;
  }
  
Future<Map<String, dynamic>> uploadReportImage({
  required int reportId,
  required XFile image,
}) async {
  final bytes = await image.readAsBytes();

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/reports/$reportId/image'),
  );

  request.files.add(
    http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: image.name,
    ),
  );

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode != 200) {
    throw Exception('Image upload failed: ${response.body}');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}
}
