import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/not_logged_in_view.dart';
import 'package:graduation/features/favorite/cubit/favorite_cubit.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';
import 'package:graduation/features/home/ui/widgets/shimmer_grid_posts_cars.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsManager.backgroundColor,
      child: context.isNotLoggedIn ? buildNotLoggedInView(context) : _buildLoggedInView(),
    );
  }

  Widget _buildLoggedInView() {
    return BlocProvider(
      create: (context) => FavoriteCubit()..getFavoriteCars(),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is LoadingFavoriteState) {
              return ShimmerGridPostsCars();
            } else if (state is Error) {
              return Center(child: Text("❌ خطأ: ${state.message}"));
            } else if (state is SuccessFavoriteState) {
              if (state.carInformation.isEmpty) {
                return Center(
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(border: Border.all(color: ColorsManager.kPrimaryColor)),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorsManager.lighterGray,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.favorite, color: ColorsManager.kPrimaryColor),
                            ),
                          ),
                          Text('لا توجة تفضيلات', style: TextStyles.font14DarkMedium),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(opacity: _animationController, child: child);
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.carInformation.length,
                  itemBuilder: (context, index) {
                    final carList = state.carInformation[index];
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final double delay = (index * 0.1).clamp(0.0, 0.9);
                        final Animation<double> delayedAnimation = CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(delay, 1.0, curve: Curves.easeOutQuad),
                        );

                        return Transform.scale(
                          scale: 0.8 + (0.2 * delayedAnimation.value),
                          child: Opacity(opacity: delayedAnimation.value, child: child),
                        );
                      },
                      child: BuildItemPostsCars(carList: carList),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
