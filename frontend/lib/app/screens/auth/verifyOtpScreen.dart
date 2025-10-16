import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final int _otpLength = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _otpLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    if (_enteredOtp.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    setState(() => _isLoading = false);

    // Navigate to registration screen
    context.push('/register');
  }

  void _resendOtp() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent')),
    );

    for (var c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Enter the 6-digit code',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
                  return SizedBox(
                    width: 48,
                    height: 58,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _isLoading ? null : _resendOtp,
                child: const Text('Resend Code'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _enteredOtp.length == _otpLength && !_isLoading ? _verifyOtp : null,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                      : const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
