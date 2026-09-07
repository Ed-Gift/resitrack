import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Student';

  final List<String> _roles = ['Student', 'Staff', 'Corridor Rep', 'Technician', 'Administrator'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Creative Hero Image (Right on Desktop, Top on Mobile)
          Positioned(
            right: 0,
            top: 0,
            bottom: isDesktop ? 0 : size.height * 0.6,
            width: isDesktop ? size.width * 0.5 : size.width,
            child: Hero(
              tag: 'auth_background',
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1541339907198-e08756ebafe1?q=80&w=2070'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Color(0x992D1B0C), BlendMode.darken), // Warmer dark overlay
                  ),
                ),
                child: !isDesktop ? null : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ResiTrack',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black45, blurRadius: 15)]),
                        ),
                        const SizedBox(height: 16),
                        const Text('New here? Join our community!', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
                        const SizedBox(height: 40),
                        OutlinedButton(
                          onPressed: () => Navigator.pushReplacement(context, _createRoute(const SignupPage())),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('SIGN UP', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Login Form (Left on Desktop, Bottom on Mobile)
          Positioned(
            left: 0,
            bottom: 0,
            top: isDesktop ? 0 : size.height * 0.35,
            width: isDesktop ? size.width * 0.5 : size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: isDesktop ? BorderRadius.zero : const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Welcome Back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                        const SizedBox(height: 30),
                        _buildTextField(_emailController, 'Email', Icons.email_outlined),
                        const SizedBox(height: 15),
                        _buildTextField(_passwordController, 'Password', Icons.lock_outline, obscure: true),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Login as Role (Demo)',
                            prefixIcon: Icon(Icons.verified_user_outlined, color: Theme.of(context).colorScheme.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                          onChanged: (v) => setState(() => _selectedRole = v!),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  initialRole: _selectedRole,
                                  userName: _selectedRole == 'Administrator' ? 'Admin User' : 'Mpumelelo Gumede',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Login'),
                        ),
                        const SizedBox(height: 20),
                        Row(children: [
                          Expanded(child: Divider(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2))),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('OR', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)))),
                          Expanded(child: Divider(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)))
                        ]),
                        const SizedBox(height: 20),
                        _buildSocialButton('Continue with Google', Colors.white, Colors.black, 'https://img.icons8.com/color/48/google-logo.png'),
                        const SizedBox(height: 10),
                        _buildSocialButton('Continue with Facebook', const Color(0xFF1877F2), Colors.white, 'https://img.icons8.com/color/48/facebook-new.png'),
                        if (!isDesktop) ...[
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(context, _createRoute(const SignupPage())),
                            child: Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, Color bgColor, Color textColor, String logoUrl) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: bgColor == Colors.white ? const BorderSide(color: Colors.grey) : BorderSide.none,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(logoUrl, height: 24, errorBuilder: (c, e, s) => Icon(Icons.account_circle, size: 24, color: textColor)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
