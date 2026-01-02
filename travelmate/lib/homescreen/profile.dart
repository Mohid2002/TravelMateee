import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      String? token = prefs.getString('token'); // must be stored at login

      if (token == null) {
        debugPrint("❌ Token not found. Please login first.");
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('http://192.168.0.103/api/user/basic-info'), // your API
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Safely get name and email
        final name = data['name'] ??
    data['data']?['name'] ??
    data['user']?['name'];
final email = data['email'] ??
    data['data']?['email'] ??
    data['user']?['email'];

nameController.text = name?.toString() ?? '';
emailController.text = email?.toString() ?? '';

      } else {
        debugPrint("❌ API error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.09),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(top: height * 0.02),
            child: const BackButton(color: Colors.black),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: height * 0.02),
            child: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.02, right: width * 0.03),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile Updated")),
                    );
                  }
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
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
                  children: [
                    SizedBox(height: height * 0.02),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/img1.png"),
                    ),
                    SizedBox(height: height * 0.015),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Change Profile Picture",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    _buildTextField("Name", nameController, TextInputType.name),
                    SizedBox(height: height * 0.02),
                    _buildTextField(
                        "Email", emailController, TextInputType.emailAddress),
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
