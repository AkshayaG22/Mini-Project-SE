
import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

const _blue = Color(0xFF0D57D5);
const _canvas = Color(0xFFF8FAFC);

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.onSignedIn,
    required this.onCreateAccount,
    super.key,
  });

  final VoidCallback onSignedIn;
  final VoidCallback onCreateAccount;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = true;
  bool submitting = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => submitting = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final dynamic data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 &&
          data is Map &&
          data['message'] == 'User logged in successfully!') {
        widget.onSignedIn();
      } else {
        final message = data is Map
            ? (data['detail'] ??
                    data['message'] ??
                    'Invalid email or password.')
                .toString()
            : 'Invalid email or password.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not connect to the FixIt server. '
            'Check that your backend is running.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  const SizedBox(height: 38),
                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Sign in to report hazards and track their resolution.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 118, 140, 171),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const FieldLabel("Email Address"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hintinput: "name@example.com",
                      icon: Icons.mail_outline_rounded,
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? "";
                      if (email.isEmpty ||
                          !email.contains("@") ||
                          !email.contains(".")) {
                        return "Enter valid Email address!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  const FieldLabel("PASSWORD"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (!submitting) signIn();
                    },
                    decoration: _inputDecoration(
                      hintinput: "Enter your password",
                      icon: Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF64748B),
                        ),
                        tooltip: obscurePassword
                            ? "Show password"
                            : "Hide password",
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return "Enter your password";
                      }
                      if ((value ?? "").length < 6) {
                        return "Password must have at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: submitting ? null : signIn,
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0x500D57D5),
                    ),
                    child: submitting
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 19),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.blueGrey.shade400,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "NEW TO FIXIT?",
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.blueGrey.shade400,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton(
                    onPressed: widget.onCreateAccount,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      "Create account",
                      style: TextStyle(
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintinput,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintinput,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 1.5,
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3D0D57D5),
                blurRadius: 16,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              color: _canvas,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FIXIT",
              style: TextStyle(
                color: _blue,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              "A better city starts with you!",
              style: TextStyle(
                color: Color.fromARGB(255, 118, 140, 171),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF475569),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    );
  }
}
