import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';
import 'package:graduation/features/home/ui/widgets/shimmer_grid_posts_cars.dart';
import 'package:graduation/features/reported_cars/ui/widgets/no_data_widget.dart';

class HomeBlocBuilder extends StatefulWidget {
  const HomeBlocBuilder({super.key});

  @override
  State<HomeBlocBuilder> createState() => _HomeBlocBuilderState();
}

class _HomeBlocBuilderState extends State<HomeBlocBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return ShimmerGridPostsCars();
        } else if (state.error != null) {
          return NoDataWidget(message: 'حدث خطأ أثناء تحميل البيانات');
        } else if (state.carInformation.isEmpty) {
          return NoDataWidget(message: 'لا توجد بيانات متاحة حالياً');
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = MediaQuery.of(context).size.width;
              final bool isTablet = screenWidth > 600;
              int crossAxisCount = isTablet ? 3 : 2;
              double aspectRatio = isTablet ? 0.75 : 0.68;
              return BuildHomeGridView(crossAxisCount: crossAxisCount, aspectRatio: aspectRatio, state: state);
            },
          );
        }
      },
    );
  }
}

class BuildHomeGridView extends StatelessWidget {
  final int crossAxisCount;
  final double aspectRatio;
  final HomeState state;

  const BuildHomeGridView({super.key, required this.crossAxisCount, required this.aspectRatio, required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: aspectRatio,
      ),
      itemCount: state.carInformation.length,
      itemBuilder: (context, index) {
        final carList = state.carInformation[index];
        return BuildItemPostsCars(carList: carList);
      },
    );
  }
}
// class HomeBlocBuilder extends StatefulWidget {
//   final AnimationController controller;
//   final bool isChangingFilter;

//   const HomeBlocBuilder({super.key, required this.controller, required this.isChangingFilter});

//   @override
//   State<HomeBlocBuilder> createState() => _HomeBlocBuilderState();
// }

// class _HomeBlocBuilderState extends State<HomeBlocBuilder> with SingleTickerProviderStateMixin {
//   late AnimationController _itemsAnimationController;

//   @override
//   void initState() {
//     super.initState();
//     _itemsAnimationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
//     _itemsAnimationController.forward();
//   }

//   @override
//   void didUpdateWidget(HomeBlocBuilder oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isChangingFilter && !oldWidget.isChangingFilter) {
//       _itemsAnimationController.reset();
//     } else if (!widget.isChangingFilter && oldWidget.isChangingFilter) {
//       _itemsAnimationController.forward();
//     }
//   }

//   @override
//   void dispose() {
//     _itemsAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return ShimmerGridPostsCars();
//         } else if (state.error != null) {
//           return Center(child: Text("❌ خطأ: ${state.error}"));
//         } else {
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               final double screenWidth = MediaQuery.of(context).size.width;
//               final bool isTablet = screenWidth > 600;
//               int crossAxisCount = isTablet ? 3 : 2;
//               double aspectRatio = isTablet ? 0.75 : 0.68;
//               return BuildHomeGridView(
//                 crossAxisCount: crossAxisCount,
//                 aspectRatio: aspectRatio,
//                 itemsAnimationController: _itemsAnimationController,
//                 state: state,
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// class BuildHomeGridView extends StatelessWidget {
//   final int crossAxisCount;
//   final double aspectRatio;
//   final AnimationController _itemsAnimationController;
//   final HomeState state;

//   const BuildHomeGridView({
//     super.key,
//     required this.crossAxisCount,
//     required this.aspectRatio,
//     required AnimationController itemsAnimationController,
//     required this.state,
//   }) : _itemsAnimationController = itemsAnimationController;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(12),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         mainAxisSpacing: 1,
//         crossAxisSpacing: 1,
//         childAspectRatio: aspectRatio,
//       ),
//       itemCount: state.carInformation.length,
//       itemBuilder: (context, index) {
//         final carList = state.carInformation[index];

//         return AnimatedBuilder(
//           animation: _itemsAnimationController,
//           builder: (context, child) {
//             final double delayStart = (index * 0.05).clamp(0.0, 0.9);
//             final Animation<double> delayedAnimation = CurvedAnimation(
//               parent: _itemsAnimationController,
//               curve: Interval(delayStart, 1.0, curve: Curves.easeOutCubic),
//             );

//             final double safeOpacity = delayedAnimation.value.clamp(0.0, 1.0);

//             return Opacity(
//               opacity: safeOpacity,
//               child: Transform.translate(
//                 offset: Offset(0, 20 * (1 - safeOpacity)),
//                 child: Transform.scale(scale: 0.9 + (0.1 * safeOpacity), child: child),
//               ),
//             );
//           },
//           child: BuildItemPostsCars(carList: carList),
//         );
//       },
//     );
//   }
// }
