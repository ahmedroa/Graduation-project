import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';
import 'package:graduation/features/home/ui/widgets/shimmer_grid_posts_cars.dart';

// إنشاء كومبوننت منفصل للـ HomeBlocBuilder يمكنه الوصول إلى متحكم الأنيميشن
class HomeBlocBuilder extends StatefulWidget {
  final AnimationController controller;
  final bool isChangingFilter;

  const HomeBlocBuilder({super.key, required this.controller, required this.isChangingFilter});

  @override
  State<HomeBlocBuilder> createState() => _HomeBlocBuilderState();
}

class _HomeBlocBuilderState extends State<HomeBlocBuilder> with SingleTickerProviderStateMixin {
  // متحكم أنيميشن خاص بالعناصر فقط
  late AnimationController _itemsAnimationController;

  @override
  void initState() {
    super.initState();
    _itemsAnimationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _itemsAnimationController.forward();
  }

  @override
  void didUpdateWidget(HomeBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إعادة تشغيل أنيميشن العناصر فقط عند تغيير الفلتر
    if (widget.isChangingFilter && !oldWidget.isChangingFilter) {
      _itemsAnimationController.reset();
    } else if (!widget.isChangingFilter && oldWidget.isChangingFilter) {
      _itemsAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _itemsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return ShimmerGridPostsCars();
        } else if (state.error != null) {
          return Center(child: Text("❌ خطأ: ${state.error}"));
        } else {
          return buildGridView(state.carInformation);
        }
      },
    );
  }

  Widget buildGridView(List<PostCar> carInformation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // حساب نسبة العرض إلى الارتفاع المناسبة بناءً على عرض الشاشة
        final double screenWidth = MediaQuery.of(context).size.width;
        final bool isTablet = screenWidth > 600;

        // تحديد عدد الأعمدة بناءً على حجم الشاشة
        int crossAxisCount = isTablet ? 3 : 2;

        // حساب النسبة المناسبة للعرض والارتفاع
        // استخدام نسبة ثابتة بدلاً من تعديل بـ .h
        double aspectRatio = isTablet ? 0.75 : 0.68;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: aspectRatio,
          ),
          itemCount: carInformation.length,
          itemBuilder: (context, index) {
            final carList = carInformation[index];

            // استخدام الأنيميشن مع كل بطاقة - نستخدم متحكم أنيميشن العناصر المستقل
            return AnimatedBuilder(
              animation: _itemsAnimationController,
              builder: (context, child) {
                // حساب تأخير للعناصر ليظهروا بشكل متسلسل
                final double delayStart = (index * 0.05).clamp(0.0, 0.9);

                final Animation<double> delayedAnimation = CurvedAnimation(
                  parent: _itemsAnimationController,
                  curve: Interval(delayStart, 1.0, curve: Curves.easeOutCubic),
                );

                final double safeOpacity = delayedAnimation.value.clamp(0.0, 1.0);

                return Opacity(
                  opacity: safeOpacity,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - safeOpacity)),
                    child: Transform.scale(scale: 0.9 + (0.1 * safeOpacity), child: child),
                  ),
                );
              },
              child: BuildItemPostsCars(carList: carList),
            );
          },
        );
      },
    );
  }
  // Widget buildGridView(List<PostCar> carInformation) {
  //   return GridView.builder(
  //     padding: const EdgeInsets.all(12),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       mainAxisSpacing: 1,
  //       childAspectRatio: 0.7.h,
  //     ),
  //     itemCount: carInformation.length,
  //     itemBuilder: (context, index) {
  //       final carList = carInformation[index];

  //       // استخدام الأنيميشن مع كل بطاقة - نستخدم متحكم أنيميشن العناصر المستقل
  //       return AnimatedBuilder(
  //         animation: _itemsAnimationController,
  //         builder: (context, child) {
  //           // حساب تأخير للعناصر ليظهروا بشكل متسلسل
  //           final double delayStart = (index * 0.05).clamp(0.0, 0.9);

  //           final Animation<double> delayedAnimation = CurvedAnimation(
  //             parent: _itemsAnimationController,
  //             curve: Interval(delayStart, 1.0, curve: Curves.easeOutCubic),
  //           );

  //           final double safeOpacity = delayedAnimation.value.clamp(0.0, 1.0);

  //           return Opacity(
  //             opacity: safeOpacity,
  //             child: Transform.translate(
  //               offset: Offset(0, 20 * (1 - safeOpacity)),
  //               child: Transform.scale(scale: 0.9 + (0.1 * safeOpacity), child: child),
  //             ),
  //           );
  //         },
  //         child: BuildItemPostsCars(carList: carList),
  //       );
  //     },
  //   );
  // }
}
