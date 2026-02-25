import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _message = null;
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Please enter email and password.';
        _isLoading = false;
      });
      return;
    }

    try {
      if (_isLogin) {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (mounted) {
          setState(() => _isLoading = false);
        }
      } else {
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
          data: _nameController.text.trim().isEmpty
              ? null
              : {'name': _nameController.text.trim()},
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
            _message = 'Check your email to confirm your account, then sign in.';
          });
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _message = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _message = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF111827),
                    const Color(0xFF1F2937),
                  ]
                : [
                    const Color(0xFF4DA3B6).withOpacity(0.15),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.school_rounded,
                        size: 56,
                        color: isDark ? Colors.white70 : const Color(0xFF4DA3B6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'EduDesk',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F181A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin ? 'Sign in to your account' : 'Create an account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (!_isLogin) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name (optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your password';
                          if (!_isLogin && v.length < 6) return 'Use at least 6 characters';
                          return null;
                        },
                      ),
                      if (_message != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: Text(
                            _message!,
                            style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _isLoading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF4DA3B6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(_isLogin ? 'Sign in' : 'Sign up'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _message = null;
                                });
                              },
                        child: Text(
                          _isLogin
                              ? "Don't have an account? Sign up"
                              : 'Already have an account? Sign in',
                          style: const TextStyle(color: Color(0xFF4DA3B6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
