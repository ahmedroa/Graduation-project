// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:graduation/features/auth/login/ui/screens/login.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (_, animation, __) {
            return FadeTransition(
              opacity: animation,
              child: BlocProvider(create: (context) => LoginCubit(), child: LoginScreen()),
            );
          },
        ),
      );
    });

    return Scaffold(
      backgroundColor: ColorsManager.kPrimaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.15),
          child: Hero(tag: "logo", child: SvgPicture.asset(ImgManager.logo, color: Colors.white, width: 140)),
        ),
      ),
    );
  }
}


// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

//     _rotationAnimation = Tween<double>(
//       begin: 0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.7, curve: Curves.easeInOut)));

//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.2,
//     ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.8, curve: Curves.elasticOut)));

//     _opacityAnimation = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

//     _controller.forward();

//     Future.delayed(const Duration(milliseconds: 2500), () {
//       Navigator.of(context).pushReplacement(
//         PageRouteBuilder(
//           transitionDuration: const Duration(seconds: 1),
//           pageBuilder: (_, animation, __) {
//             return FadeTransition(
//               opacity: animation,
//               child: BlocProvider(create: (context) => LoginCubit(), child: LoginScreen()),
//             );
//           },
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: ColorsManager.kPrimaryColor,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return CustomPaint(
//                   painter: WaveBackgroundPainter(progress: _controller.value, color: Colors.white.withOpacity(0.1)),
//                 );
//               },
//             ),
//           ),

//           Center(
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _scaleAnimation.value,
//                   child: Transform.rotate(
//                     angle: _rotationAnimation.value,
//                     child: Opacity(
//                       opacity: _opacityAnimation.value,
//                       child: Container(
//                         padding: EdgeInsets.all(size.width * 0.1),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.white.withOpacity(0.2),
//                               blurRadius: 30 * _opacityAnimation.value,
//                               spreadRadius: 10 * _opacityAnimation.value,
//                             ),
//                           ],
//                         ),
//                         child: Hero(
//                           tag: "logo",
//                           child: SvgPicture.asset(ImgManager.logo, color: Colors.white, width: 120),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           Positioned(
//             bottom: size.height * 0.15,
//             left: 0,
//             right: 0,
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Opacity(
//                   opacity: _controller.value,
//                   child: Transform.translate(
//                     offset: Offset(0, 20 * (1 - _controller.value)),
//                     child: const Text(
//                       "مرحباً بك",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WaveBackgroundPainter extends CustomPainter {
//   final double progress;
//   final Color color;

//   WaveBackgroundPainter({required this.progress, required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = color
//           ..style = PaintingStyle.fill;

//     final path = Path();

//     path.moveTo(0, size.height * 0.7);

//     for (int i = 0; i < size.width.toInt(); i++) {
//       final x = i.toDouble();
//       final waveHeight = math.sin((x / size.width * 4 * math.pi) + (progress * math.pi * 4)) * (size.height * 0.05);
//       final y = size.height * 0.7 + waveHeight;
//       path.lineTo(x, y);
//     }

//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     canvas.drawPath(path, paint);

//     // رسم دوائر متحركة
//     for (int i = 0; i < 5; i++) {
//       final circleRadius = size.width * 0.06 * (1 + (i * 0.4));
//       final circleX = size.width * 0.3 + math.cos(progress * math.pi * 2 + (i * 0.7)) * (size.width * 0.2);
//       final circleY = size.height * 0.3 + math.sin(progress * math.pi * 2 + (i * 0.7)) * (size.height * 0.2);

//       canvas.drawCircle(
//         Offset(circleX, circleY),
//         circleRadius * (0.3 + (math.sin(progress * math.pi * 2) * 0.2)),
//         Paint()..color = color.withOpacity(0.1),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
