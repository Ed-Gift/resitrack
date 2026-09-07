import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // Exit the app when back is pressed on the landing icon screen
          SystemNavigator.pop();
        },
        child: GestureDetector(
          onTap: _enterApp,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image (Hero tag for transition to Login)
              Hero(
                tag: 'auth_background',
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1541339907198-e08756ebafe1?q=80&w=2070'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Color(0x992D1B0C), BlendMode.darken), // Warmer dark overlay
                    ),
                  ),
                ),
              ),
              // Centered Icon and Title
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF0).withValues(alpha: 0.9), // Warmer off-white
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3E2723).withValues(alpha: 0.3), // Warmer shadow
                            blurRadius: 30,
                            spreadRadius: 10,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.apartment_rounded,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'ResiTrack',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                            shadows: [Shadow(color: Colors.black45, blurRadius: 15)],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'SMART RESIDENCY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'TAP TO START',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
