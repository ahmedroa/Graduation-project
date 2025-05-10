import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/features/profile/cubit/profile_cubit.dart';
import 'package:graduation/features/profile/cubit/profile_state.dart';
import 'dart:async';

import 'package:graduation/features/profile/ui/widgets/animated_form_fields.dart';
import 'package:graduation/features/profile/ui/widgets/profile_shimmer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _cardOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.easeOut)));

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.65, curve: Curves.easeOut)));

    Timer(const Duration(milliseconds: 150), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundColor,
        appBar: AppBar(title: const Text('الملف الشخصي'), backgroundColor: Colors.white, elevation: 0),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileStateLoading) {
              return ProfileShimmer();
            } else if (state is ProfileStateError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().getUserData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.kPrimaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileStateLoaded) {
              return Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _cardOpacity,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AnimatedFormFields(
                              name: state.name,
                              phoneNumber: state.phoneNumber,
                              email: state.email,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('جاري تحميل البيانات...'));
          },
        ),
      ),
    );
  }
}
