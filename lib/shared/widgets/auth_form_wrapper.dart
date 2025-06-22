import 'package:flutter/material.dart';

class AuthFormWrapper extends StatefulWidget {
  final Widget child;
  final String title;

  const AuthFormWrapper({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  State<AuthFormWrapper> createState() => _AuthFormWrapperState();
}

class _AuthFormWrapperState extends State<AuthFormWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundDecoration(),
          Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeIn!,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      widget.child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundDecoration extends StatelessWidget {
  const BackgroundDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(),
      child: Container(),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.deepPurple.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 100, paint1);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.1), 70, paint2);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.8), 120, paint2);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.9), 80, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
