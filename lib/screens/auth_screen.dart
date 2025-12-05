import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;

  Future<void> _submit() async {
    final email = _email.text.trim();
    final pass = _password.text;
    if (email.isEmpty || pass.isEmpty) return;
    setState(() => _loading = true);
    try {
      if (_isSignUp) {
        await SupabaseService.signUp(email, pass);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign up successful — check email for confirmation if required')));
      } else {
        await SupabaseService.signIn(email, pass);
      }
    } catch (e) {
      // Show a user-friendly message when possible
      final msg = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auth error: $msg')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(_isSignUp ? 'Create account' : 'Sign in'),
                const Spacer(),
                Switch(value: _isSignUp, onChanged: (v) => setState(() => _isSignUp = v)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const CircularProgressIndicator() : Text(_isSignUp ? 'Sign up' : 'Sign in')),
            )
          ],
        ),
      ),
    );
  }
}
