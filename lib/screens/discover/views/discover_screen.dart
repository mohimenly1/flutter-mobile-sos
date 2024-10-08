import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_stepper/easy_stepper.dart';

class MyReportScreen extends StatefulWidget {
  const MyReportScreen({super.key});

  @override
  _MyReportScreenState createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  List<dynamic> reports = [];
  bool isLoading = true;
  int activeStep = 0; // Stepper control
  String selectedStatus = 'all'; // To track the selected status for filtering

  @override
  void initState() {
    super.initState();
    fetchReports(); // Initial fetch for all reports
  }

  // Fetch reports from the API (optionally filtered by status)
  Future<void> fetchReports({String? status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle case where token is not found
      return;
    }

    String url = 'https://sos.mohimen.ly/api/user/reports';
    if (status != null) {
      url += '?status=$status'; // Append status filter to URL
    }

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

  // Build individual report widget
  Widget buildReportStep(dynamic report) {
    String status = report['status'] ?? 'No Status';
    String superUserReply = report['super_user_reply'] ?? 'No Data Found';

    // Assign color based on status
    Color statusColor;
    switch (status) {
      case 'answered':
        statusColor = Colors.green; // Smooth green background
        break;
      case 'refused':
        statusColor = Colors.red; // Light red
        break;
      case 'pending':
        statusColor = Colors.orange; // Light orange
        break;
      default:
        statusColor = Colors.grey.withOpacity(0.3); // Default grey
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Report ID: ${report['id']}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            "Category: ${report['category'] ?? 'N/A'}",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            "Classification: ${report['classification'] ?? 'N/A'}",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            "Content: ${report['content_report']}",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            "Status: $status",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            "Super User Reply: $superUserReply",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Stepper widget to filter reports by status
  Widget buildReportStepper() {
    return EasyStepper(
      activeStep: activeStep,
      onStepReached: (index) {
        setState(() {
          activeStep = index;
          // Map the step index to a status
          if (index == 0) {
            selectedStatus = 'pending';
          } else if (index == 1) {
            selectedStatus = 'refused';
          } else if (index == 2) {
            selectedStatus = 'answered';
          }
          fetchReports(status: selectedStatus); // Fetch reports based on status
        });
      },
      steps: const [
        EasyStep(
          icon: Icon(Icons.pending_actions),
          title: 'قيد الإنتظار',
        ),
        EasyStep(
          icon: Icon(Icons.close),
          title: 'مرفوضة',
        ),
        EasyStep(
          icon: Icon(Icons.check_circle),
          title: 'تم الموافقة',
        ),
      ],
      stepShape: StepShape.rRectangle, // Rectangular step shape
      stepBorderRadius: 10,
      finishedStepBorderColor: Colors.green,
      activeStepBackgroundColor: Colors.green.withOpacity(0.3),
      finishedStepBackgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "بلاغاتي المرسلة",
            style: TextStyle(fontFamily: 'TajawalRegular'),
          ),
        ),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    // Stepper to filter reports
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: buildReportStepper(),
                    ),
                    const SizedBox(height: 20),
                    // Display filtered reports
                    Expanded(
                      child: reports.isEmpty
                          ? const Center(child: Text("No reports found."))
                          : ListView(
                              padding: const EdgeInsets.all(defaultPadding),
                              children: reports
                                  .map((report) => buildReportStep(report))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
