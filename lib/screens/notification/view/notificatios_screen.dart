import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports(); // Fetch the reports when the screen is initialized
  }

  // Fetch reports from the API
  Future<void> fetchReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle case where token is not found
      return;
    }

    String url = 'https://sos.mohimen.ly/api/user/reports';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        reports = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  // Build individual notification widget
  Widget buildNotificationItem(dynamic report) {
    String status = report['status'] ?? 'No Status';
    String category = report['category'] ?? 'N/A';
    String classification = report['classification'] ?? 'N/A';

    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      title: Text("Category: $category",
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Classification: $classification"),
          Text("Status: $status"),
        ],
      ),
      leading: const Icon(Icons.notifications),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return buildNotificationItem(reports[index]);
              },
            ),
    );
  }
}
