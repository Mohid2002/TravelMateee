import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelmate/homescreen/calander_schedule.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserBasicInfo();
  }

  /// 🔹 Fetch user info from API
  Future<void> fetchUserBasicInfo() async {
    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('http://192.168.0.103/api/user/basic-info'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final name =
            data['name'] ?? data['data']?['name'] ?? data['user']?['name'];
        final email =
            data['email'] ?? data['data']?['email'] ?? data['user']?['email'];

        nameController.text = name?.toString() ?? '';
        emailController.text = email?.toString() ?? '';
      }
    } catch (e) {
      debugPrint("❌ Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated")),
                );
              }
            },
            child: const Text("Done",
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/img1.png"),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {},
                      child: const Text("Change Profile Picture",
                          style: TextStyle(color: Colors.blue)),
                    ),

                    const SizedBox(height: 25),

                    _buildTextField(
                        "Name", nameController, TextInputType.name),

                    const SizedBox(height: 20),

                    _buildTextField(
                        "Email", emailController, TextInputType.emailAddress),

                    const SizedBox(height: 30),

                    /// ✅ MY SCHEDULED TRIPS BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CalendarSchedule(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_month,
                                color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              "My Scheduled Trips",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter $label" : null,
    );
  }
}
