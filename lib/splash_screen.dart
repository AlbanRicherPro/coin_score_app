import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  late final Animation<double> _scale;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    int playCount = 0;
    _audioPlayer.onPlayerComplete.listen((event) async {
      playCount++;
      if (playCount < 2) {
        await Future.delayed(const Duration(milliseconds: 10));
        await _audioPlayer.play(AssetSource('sounds/quack.mp3'));
      }
    });
    _audioPlayer.play(AssetSource('sounds/quack.mp3'));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    // Rotation: starts slow, speeds up, then slows to a stop
    _rotation = Tween<double>(begin: 0, end: 2 * 3.14159)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    ));
    // Scale: grows a bit then returns to original
    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);
    _controller.forward();

    Timer(const Duration(milliseconds: 1800), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4b9fc6),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotation.value,
              child: Transform.scale(
                scale: _scale.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/images/splash.png',
            width: MediaQuery.of(context).size.width * 0.6,
          ),
        ),
      ),
    );
  }
}
