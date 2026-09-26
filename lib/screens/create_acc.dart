import "package:flutter/material.dart";

const _blue = Color(0xFF0D57D5);
const _canvas = Color(0xFFF8FAFC);

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({
    required this.onAccountCreated,
    required this.onBackToLogin,
    super.key,
  });

  final VoidCallback onAccountCreated;
  final VoidCallback onBackToLogin;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;
  // bool acceptedTerms = false;
  bool submitting = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // if (!acceptedTerms) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Please accept the terms and privacy policy."),
    //     ),
    //   );
    //   return;
    // }

    setState(() => submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    widget.onAccountCreated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AccountHeader(onBack: widget.onBackToLogin),
                    const SizedBox(height: 36),
                    const Text(
                      "JOIN YOUR COMMUNITY",
                      style: TextStyle(
                        color: _blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      "Create your account",
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 29,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      "Report local hazards, validate community reports, and follow issues through resolution.",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _NameField(
                            label: "FIRST NAME",
                            hint: "Aarav",
                            controller: firstNameController,
                            autofillHint: AutofillHints.givenName,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _NameField(
                            label: "LAST NAME",
                            hint: "Kumar",
                            controller: lastNameController,
                            autofillHint: AutofillHints.familyName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel("EMAIL ADDRESS"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: _inputDecoration(
                        hintText: "name@example.com",
                        icon: Icons.mail_outline_rounded,
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? "";
                        if (email.isEmpty) return "Enter your email address";
                        if (!email.contains("@") || !email.contains(".")) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel("MOBILE NUMBER"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      decoration: _inputDecoration(
                        hintText: "98765 43210",
                        icon: Icons.phone_outlined,
                        prefixText: "+91  ",
                      ),
                      validator: (value) {
                        final digits = (value ?? "").replaceAll(
                          RegExp(r"\D"),
                          "",
                        );
                        if (digits.length < 10) {
                          return "Enter a valid mobile number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel("CREATE PASSWORD"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      onFieldSubmitted: (_) => createAccount(),
                      decoration: _inputDecoration(
                        hintText: "At least 8 characters",
                        icon: Icons.lock_outline_rounded,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => showPassword = !showPassword,
                          ),
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF64748B),
                          ),
                          tooltip: showPassword
                              ? "Hide password"
                              : "Show password",
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? "").length < 8) {
                          return "Password must have at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     SizedBox(
                    //       width: 24,
                    //       height: 24,
                    //       child: Checkbox(
                    //         value: acceptedTerms,
                    //         activeColor: _blue,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //         onChanged: (value) => setState(
                    //           () => acceptedTerms = value ?? false,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 10),
                    //     Expanded(
                    //       child: Text.rich(
                    //         TextSpan(
                    //           style: const TextStyle(
                    //             color: Color(0xFF475569),
                    //             fontSize: 12,
                    //             height: 1.55,
                    //           ),
                    //           children: const [
                    //             TextSpan(text: "I agree to the "),
                    //             TextSpan(
                    //               text: "Terms of Service",
                    //               style: TextStyle(
                    //                 color: _blue,
                    //                 fontWeight: FontWeight.w800,
                    //               ),
                    //             ),
                    //             TextSpan(text: " and "),
                    //             TextSpan(
                    //               text: "Privacy Policy",
                    //               style: TextStyle(
                    //                 color: _blue,
                    //                 fontWeight: FontWeight.w800,
                    //               ),
                    //             ),
                    //             TextSpan(text: "."),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: submitting ? null : createAccount,
                      style: FilledButton.styleFrom(
                        backgroundColor: _blue,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
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
                                  "Create account",
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onBackToLogin,
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Container(
                    //   padding: const EdgeInsets.all(15),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFFECFDF5),
                    //     borderRadius: BorderRadius.circular(17),
                    //     border: Border.all(color: const Color(0xFFD1FAE5)),
                    //   ),
                    //   // child: const Row(
                    //   //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   //   children: [
                    //   //     Icon(
                    //   //       Icons.verified_user_outlined,
                    //   //       color: Color(0xFF047857),
                    //   //       size: 20,
                    //   //     ),
                    //   //     SizedBox(width: 10),
                    //   //     // Expanded(
                    //   //     //   child: Text(
                    //   //     //     "Privacy first. Your contact details are used only for report updates and account security.",
                    //   //     //     style: TextStyle(
                    //   //     //       color: Color(0xFF065F46),
                    //   //     //       fontSize: 11,
                    //   //     //       height: 1.5,
                    //   //     //     ),
                    //   //     //   ),
                    //   //     // ),
                    //   //   ],
                    //   // ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),

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
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
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
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 12),
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
              "A better city starts with you",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
            ),
          ],
        ),
        const Spacer(),
        IconButton.outlined(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: "Back to sign in",
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.autofillHint,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String autofillHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: [autofillHint],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          validator: (value) => (value?.trim().isEmpty ?? true)
              ? "Required"
              : null,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

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
