import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

const _blue = Color(0xFF0D57D5);
const _canvas = Color(0xFFF8FAFC);


class LoginScreen extends StatefulWidget {
  
  const LoginScreen({required this.onSignedIn, super.key});

  final VoidCallback onSignedIn;

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
  //---------------
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //SENDING DETAILS TO BACKEND  (unsure)...
  Future<void> signIn() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    widget.onSignedIn();
  }
  // Future<void> signIn() async {
  //   if (!(formKey.currentState?.validate() ?? false)) return;

  //   final email = emailController.text.trim();
  //   final password = passwordController.text;

  //   // Example: print them
  //   print("Email: $email, Password: $password");

  //   // TODO: send to backend
  //   await sendToBackend(email, password);
  // }

  //-----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: ConstrainedBox(constraints:const BoxConstraints(maxWidth: 430),
            child: Form(
              key: formKey,
                child:  Column(
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
                      fontWeight: FontWeight(900),
                      letterSpacing: -0.7,
                    ),
                  ),

                  const Text(
                    "Sign in to report hazards and track their resolution.",
                    style: TextStyle(
                      color:  Color.fromARGB(255, 118, 140, 171),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const FieldLabel("Email Address"),
                  const SizedBox(height: 8),
                  TextFormField(
                    //for email
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(hintinput: "name@example.com", icon: Icons.mail_outline_rounded),
                    validator:(value) {
                      final email = value?.trim() ?? "";
                      if (email.isEmpty||!email.contains("@")|| !email.contains(".")) return "Enter valid Email address!";
                      return null;                 
                    },
                  ),
                  const SizedBox(height: 18),
                  const FieldLabel("PASSWORD"),
                  const SizedBox(height: 8),
                  //for password
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => signIn(),
                    decoration: _inputDecoration(
                      hintinput: "Enter your password",
                      icon: Icons.lock_outline_rounded,
                    ).copyWith(
                      //overrides the existing input decor
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => obscurePassword = !obscurePassword,
                          //so when "eye" button is pressed we see the password
                        ),

                        icon: Icon(
                          obscurePassword? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFF64748B),
                        ),

                        tooltip: obscurePassword
                            ? "Show password"
                            : "Hide password",
                            //shows up when hovered over icon
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? "").isEmpty) return "Enter your password";
                      if ((value ?? "").length < 6) {
                        return "Password must have at least 6 characters";
                      }
                      return null;
                    },
                  ),
                //The Sign In button
                const SizedBox(height: 18),
                //if submitted, disable the button and show icon else enable button 
                FilledButton(
                  onPressed: submitting? null: signIn,
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Color(0x500D57D5),
                  ), child: submitting? const SizedBox(
                    width: 23,
                    height:23,
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
                SizedBox(height: 16),
                Row(
                  children: [
                    
                    // const Expanded(child: Divider()),
                    Expanded(
                      child: Divider(
                      color: Colors.blueGrey.shade400,
                      thickness: 1,
                      ),
                    ),
                    // Divider(color: Colors.blueGrey.shade400, thickness: 0.5, height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "NEW TO FIXIT?",
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                        )
                      )
                    ,),
                    Expanded(
                      child: Divider(
                      color: Colors.blueGrey.shade400,
                      thickness: 1,
                      ),
                    ),
                  ],),
                  const SizedBox(height:18),
                  OutlinedButton(
                    onPressed: ()=> _showRegistrationMessage(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: BorderSide(color:Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                    ),
                    child: Text(
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

  InputDecoration _inputDecoration({required String hintinput,required IconData icon}){
    return InputDecoration(
      hintText: hintinput,
      hintStyle: const TextStyle(
        color: Color(0xFF94A3B8),
      ),

      prefixIcon: Icon(icon),
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

  void _showResetMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset link requested.")),
    );
  }

  void _showRegistrationMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Citizen registration is loading.")),
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
          margin: EdgeInsets.all(0),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.circular(14),
              boxShadow: const[ BoxShadow(
                color: Color(0x3D0D57D5),
                blurRadius: 16,
                offset: Offset(0,7),
              )
            ],
          ),
          
        child: Center( // <-- must be inside child:
            child: Icon(Icons.check_rounded, color: _canvas, size: 30),
          ),        
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
                "FIXIT",
                style: TextStyle(
                  color:_blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
            ),
            Text(
              "A better city starts with you!",
              style: TextStyle(
                color: const Color.fromARGB(255, 118, 140, 171)
              ),
              textAlign: TextAlign.left,
            ),
          ])
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
      style: TextStyle(
        color: Color(0xFF475569),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      )
    );
  }
}


