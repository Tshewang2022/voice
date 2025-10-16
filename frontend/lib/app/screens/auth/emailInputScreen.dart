import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // submit button;
  void _submitEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate API call

    setState(() => _isLoading = false);

    // Navigate to the next screen (e.g., register)
    context.push('/verify-otp'); // make sure this route exists
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Email'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            // there should be the logo here;


            // Info Text
            Text(
              'Please enter your email address to continue.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Email Input
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitEmail,
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text('Continue'),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
