import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentNumberController = TextEditingController();
  String _userRole = 'Student';
  String? _selectedSchool;

  final List<String> _schools = [
    'University of Cape Town',
    'University of the Witwatersrand',
    'University of Pretoria',
    'Stellenbosch University',
    'University of Johannesburg',
    'University of KwaZulu-Natal',
    'North-West University',
    'University of the Western Cape',
    'Rhodes University',
    'Nelson Mandela University',
    'University of Fort Hare',
    'University of the Free State',
    'University of Limpopo',
    'University of Venda',
    'University of Zululand',
    'Walter Sisulu University',
    'University of Mpumalanga',
    'Sol Plaatje University',
    'Sefako Makgatho Health Sciences University',
    'Mangosuthu University of Technology',
    'Durban University of Technology',
    'Central University of Technology',
    'Tshwane University of Technology',
    'Vaal University of Technology',
    'Cape Peninsula University of Technology',
    'University of South Africa (UNISA)',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Creative Hero Image (Left on Desktop, Top on Mobile)
          Positioned(
            left: 0,
            top: 0,
            bottom: isDesktop ? 0 : size.height * 0.65,
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
                        const Text('Already have an account?', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
                        const SizedBox(height: 40),
                        OutlinedButton(
                          onPressed: () => Navigator.pushReplacement(context, _createRoute(const LoginPage())),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('LOG IN', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Signup Form (Right on Desktop, Bottom on Mobile)
          Positioned(
            right: 0,
            bottom: 0,
            top: isDesktop ? 0 : size.height * 0.3,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 25),
                          _buildTextField(_nameController, 'Full Name', Icons.person_outline),
                          const SizedBox(height: 15),
                          _buildTextField(_emailController, 'Email', Icons.email_outlined, isEmail: true),
                          const SizedBox(height: 15),
                          if (_userRole == 'Student') ...[
                            _buildTextField(_studentNumberController, 'Student Number', Icons.badge_outlined),
                            const SizedBox(height: 15),
                          ],
                          _buildTextField(_passwordController, 'Password', Icons.lock_outline, obscure: true),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Register as:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 0,
                            children: [
                              _buildRoleRadio('Student'),
                              _buildRoleRadio('Staff'),
                              _buildRoleRadio('Corridor Rep'),
                              _buildRoleRadio('Technician'),
                              _buildRoleRadio('Administrator'),
                            ],
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            dropdownColor: Theme.of(context).colorScheme.surface,
                            decoration: InputDecoration(
                              labelText: 'Select University',
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.school_outlined),
                            ),
                            initialValue: _selectedSchool,
                            items: _schools.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (v) => setState(() => _selectedSchool = v),
                            validator: (value) => value == null ? 'Please select a university' : null,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      initialRole: _userRole,
                                      userName: _nameController.text.isNotEmpty ? _nameController.text : null,
                                      studentNumber: _studentNumberController.text.isNotEmpty ? _studentNumberController.text : null,
                                      university: _selectedSchool,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Sign Up'),
                          ),
                          if (!isDesktop) ...[
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(context, _createRoute(const LoginPage())),
                              child: Text(
                                "Already have an account? Login",
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

  Widget _buildRoleRadio(String role) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: role,
          groupValue: _userRole,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (v) => setState(() {
            _userRole = v!;
            if (_userRole != 'Student') {
              _studentNumberController.clear();
            }
          }),
        ),
        Text(
          role,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        if (obscure && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
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
}
