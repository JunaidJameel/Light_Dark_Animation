import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final primaryColorLight = const Color(0xFFD8E0ED);
  final primaryColorDark = const Color(0xFF2E3243);

  var isPressed = false;
  var isDark = false;
  bool isAnimating = false;
  bool _compositionInitialized = false;

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void toggleTheme() async {
    if (isAnimating) return;
    isAnimating = true;

    // Update theme state
    setState(() {
      isDark = !isDark;
    });

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

    // Animate forward or reverse to 0.5 mark and stop
    if (isDark) {
      await _lottieController.animateTo(
        0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      await _lottieController.animateBack(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    _lottieController.stop(); // Pause at final frame

    isAnimating = false;
  }

  Widget dayNight() {
    final positionShadow = isDark ? -40.0 : -210.0;

    return Stack(
      children: [
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark
                  ? [
                      const Color.fromARGB(255, 242, 242, 246),
                      const Color(0xFF8D81DD),
                    ]
                  : [
                      const Color(0xFFFFCC81),
                      const Color(0xFFFF6E30),
                    ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          top: positionShadow,
          right: positionShadow,
          child: Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? primaryColorDark : primaryColorLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget centerText() {
    return Text(
      isDark ? 'Good\nNight' : 'Good\nMorning',
      textAlign: TextAlign.center,
      style: GoogleFonts.oswald(
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: isDark ? primaryColorLight : primaryColorDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? primaryColorDark : primaryColorLight,
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dayNight(),
              const SizedBox(height: 30),
              centerText(),
              GestureDetector(
                onTap: toggleTheme,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    'assets/lottie/animation.json',
                    controller: _lottieController,
                    onLoaded: (composition) {
                      if (!_compositionInitialized) {
                        _lottieController.duration = composition.duration;
                        _lottieController.value = isDark ? 1.0 : 0.0;
                        _compositionInitialized = true;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
