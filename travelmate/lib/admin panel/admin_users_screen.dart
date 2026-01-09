import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelmate/loginpage/loginpage.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List users = [];
  bool loading = true;
  bool error = false;
  String? token;

  @override
  void initState() {
    super.initState();
    loadTokenAndFetchUsers();
  }

  Future<void> loadTokenAndFetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("admin_token");

    if (token == null) {
      setState(() {
        error = true;
        loading = false;
      });
      print("No admin token found!");
      return;
    }

    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      final response = await http.get(
        Uri.parse("http://192.168.100.59:5000/api/admin/users"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          users = data["users"] ?? [];
          loading = false;
        });
      } else {
        setState(() {
          error = true;
          loading = false;
        });
        print("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        error = true;
        loading = false;
      });
      print("Exception while fetching users: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("http://192.168.100.59:5000/api/admin/delete-user/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          users.removeWhere((user) => user["_id"] == id);
        });
        showSnackBar("User deleted successfully.");
      } else {
        showSnackBar("Failed to delete user.");
      }
    } catch (e) {
      showSnackBar("Error deleting user.");
    }
  }

  Future<void> blockUser(String id) async {
  try {
    final response = await http.patch(
      Uri.parse("http://192.168.100.59:5000/api/admin/block-user/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        users = users.map((user) {
          if (user["_id"] == id) {
            user["isBlocked"] = true;
          }
          return user;
        }).toList();
      });

      showSnackBar("User blocked successfully.");
    } else {
      print("Block failed: ${response.statusCode} ${response.body}");
      showSnackBar("Failed to block user.");
    }
  } catch (e) {
    print("Block exception: $e");
    showSnackBar("Error blocking user.");
  }
}


  Future<void> unBlockUser(String id) async {
    try {
      final response = await http.patch(
        Uri.parse("http://192.168.100.59:5000/api/admin/unblock-user/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          users = users.map((user) {
            if (user["_id"] == id) user["isBlocked"] = false;
            return user;
          }).toList();
        });
        showSnackBar("User unblocked successfully.");
      } else {
        showSnackBar("Failed to unblock user.");
      }
    } catch (e) {
      showSnackBar("Error unblocking user.");
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("admin_token");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // your login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel - Users"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                : error
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
                            const SizedBox(height: 10),
                            const Text(
                              "Failed to load users 😞",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: fetchUsers,
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : users.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.person_off, size: 80, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  "No Users Found",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user["isBlocked"] == true
                                        ? Colors.redAccent
                                        : Colors.green,
                                    child: Text(
                                      user["name"] != null && user["name"].isNotEmpty
                                          ? user["name"][0].toUpperCase()
                                          : "?",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(user["name"] ?? "No Name"),
                                  subtitle: Text(user["email"] ?? "No Email"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          user["isBlocked"] == true
                                              ? Icons.lock_open
                                              : Icons.lock,
                                          color: user["isBlocked"] == true
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        onPressed: () {
                                          user["isBlocked"] == true
                                              ? unBlockUser(user["_id"])
                                              : blockUser(user["_id"]);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => deleteUser(user["_id"]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          // Logout button at bottom
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: logout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
