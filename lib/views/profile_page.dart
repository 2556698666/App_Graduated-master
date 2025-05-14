
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/widget/custom_bottom_bar.dart';
import 'package:app/widget/text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://school_mangment.test/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Logout error: \$e');
    }
  }
  String? id;
  String? name;
  String? email;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("No token found");
      }

      final response = await http.get(
        Uri.parse('http://school_mangment.test/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          id = data['id'].toString();
          name = data['name'];
          email = data['email'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load profile");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff1265ae),
          toolbarHeight: 200,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          centerTitle: true,
          title: const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
            customTextField(
            text1: 'ID',
            text2: id ?? '',
            validH: 25,
            validV: 15,
            enabled: false,
          ),
          customTextField(
            text1: 'Name',
            text2: name ?? '',
            validH: 25,
            validV: 15,
            enabled: false,
          ),
          customTextField(
            text1: 'Email',
            text2: email ?? '',
            validH: 25,
            validV: 15,
            enabled: false,
          ),
          customTextField(
            text1: 'Change password',
            text2: '***********',
            validH: 25,
            validV: 15,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xff1265ae),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: logout,
                child: const Center(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          )],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xff1265ae),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: 100,
          child: const CustomBottomBar(),
        ),
      ),
    );
  }
}
