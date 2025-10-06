import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpRequest extends StatefulWidget {
  const OtpRequest({super.key});
  @override
  State<OtpRequest> createState() => _OtpRequestScreenState();
}
// why does this api integrations fails
class _OtpRequestScreenState extends State<OtpRequest> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  static const String otpApiUrl = 'http://192.168.131.220:3000/api/v1/common/generate-otp';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  Future<void> _generateOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final requestBody = {
        'email': _emailController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(otpApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully!'), backgroundColor: Colors.green),
        );

        // Navigate to Verify OTP screen
        Navigator.pushNamed(
          context,
          '/verify-otp',
          arguments: {
            'email': _emailController.text.trim()
          },
        );
      } else {
        final data = jsonDecode(response.body);
        final msg = data['message'] ?? 'Failed to generate OTP';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter your email'
                      : (!_isValidEmail(v.trim()) ? 'Invalid email' : null),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _generateOtp,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send OTP', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
