import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For taking a photo
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'LocationPicker.dart';
import 'package:shop/route/route_constants.dart';

class ClassificationScreen extends StatefulWidget {
  final int classificationId; // Accept classification ID

  const ClassificationScreen({super.key, required this.classificationId});

  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  List<Map<String, dynamic>> categories = []; // Store both ID and name
  String? selectedCategoryId; // Change to store selected category ID
  bool isLoading = true;
  TextEditingController contentReportController = TextEditingController();
  File? _photo;
  List<File> attachedFiles = [];
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    fetchCategoriesByClassification();
  }

  Future<void> fetchCategoriesByClassification() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://sos.mohimen.ly/api/classifications/${widget.classificationId}/categories'),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          categories = jsonResponse.map((data) {
            return {
              'id': data['id'], // Assuming each category has an 'id'
              'name': data['name'].toString(),
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadFiles() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      attachedFiles =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  Future<void> selectLocation() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          onLocationSelected: (lat, lng) {
            setState(() {
              latitude = lat;
              longitude = lng;
            });
          },
        ),
      ),
    );
  }

  Future<void> submitReport() async {
    print("Latitude: $latitude, Longitude: $longitude");
    if (selectedCategoryId == null ||
        contentReportController.text.isEmpty ||
        latitude == null ||
        longitude == null) {
      showAlertDialog(context, "Error", "All fields must be filled.");
      return;
    }

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        showAlertDialog(
            context, "Error", "No token found, user is not authenticated.");
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://sos.mohimen.ly/api/reports'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Prepare the fields for the request
      String classificationId = widget.classificationId.toString();
      String categoryId = selectedCategoryId!;
      String contentReport = contentReportController.text;
      String latitudeStr = latitude.toString();
      String longitudeStr = longitude.toString();

      // Add fields to the request
      request.fields['classification_id'] = classificationId;
      request.fields['category_id'] = categoryId;
      request.fields['content_report'] = contentReport;
      request.fields['latitude'] = latitudeStr;
      request.fields['longitude'] = longitudeStr;

      // Attach photo if present
      if (_photo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', _photo!.path));
      }

      // Attach any additional files
      for (var file in attachedFiles) {
        request.files.add(
            await http.MultipartFile.fromPath('attached_files[]', file.path));
      }

      // Send the request and get the response
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      // Print response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${responseData.body}");

      if (response.statusCode == 201) {
        // Show success message and redirect after 2 seconds
        showAlertDialog(context, "Success", "Report submitted successfully.");
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, entryPointScreenRoute);
      } else {
        // Show failure message with detailed server response
        showAlertDialog(context, "Error",
            "Failed to submit report. Status: ${response.statusCode}, Body: ${responseData.body}");
      }
    } catch (e) {
      showAlertDialog(context, "Error", "Error submitting report: $e");
    }
  }

// Helper function to display an alert dialog
  void showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Report'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      hint: const Text("Select a category"),
                      isExpanded: true,
                      value: selectedCategoryId, // Use selectedCategoryId
                      items: categories.map((Map<String, dynamic> category) {
                        return DropdownMenuItem<String>(
                          value: category['id'].toString(), // Set value to ID
                          child: Text(category['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value; // Set selected ID
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: contentReportController,
                      decoration: const InputDecoration(
                          labelText: 'Report Description'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: pickPhoto,
                      child: const Text("Take a Picture"),
                    ),
                    _photo != null ? Image.file(_photo!) : Container(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadFiles,
                      child: const Text("Attach Files"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: selectLocation,
                      child: const Text("Open Map to Select Location"),
                    ),
                    latitude != null && longitude != null
                        ? Text("Selected Location: ($latitude, $longitude)")
                        : Container(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: submitReport,
                      child: const Text("Submit Report"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
