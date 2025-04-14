import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/favorite/cubit/favorite_cubit.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';
import 'package:graduation/features/home/ui/widgets/shimmer_grid_posts_cars.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(),
      body:
      // context.isNotLoggedIn
      //     ? Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Icon(Icons.person_add_alt_outlined, size: 100, color: ColorsManager.kPrimaryColor),
      //           verticalSpace(12),
      //           Text('سجل دخولك', style: TextStyles.font30BlackBold),
      //           Text('لإضافة السيارات إلى المفضلة', style: TextStyles.font12GreyRegular),
      //           verticalSpace(20),
      //           MainButton(text: 'سجل دخول؛', onTap: () {}),
      //           verticalSpace(70),
      //         ],
      //       ),
      //     )
      //     :
      BlocProvider(
        create: (context) => FavoriteCubit()..getFavoriteCars(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  if (state is LoadingFavoriteState) {
                    return ShimmerGridPostsCars();
                  } else if (state is Error) {
                    return Center(child: Text("❌ خطأ: ${state.message}"));
                  } else {
                    return Expanded(
                      child:
                          state is SuccessFavoriteState
                              ? state.carInformation.isNotEmpty
                                  ? GridView.builder(
                                    padding: const EdgeInsets.all(12),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 1,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount: state.carInformation.length,
                                    itemBuilder: (context, index) {
                                      final carList = state.carInformation[index];
                                      return BuildItemPostsCars(carList: carList);
                                    },
                                  )
                                  : Center(
                                    child: Text('لا توجد سيارات مفضلة', style: TextStyles.font12PrimaryColorRegular),
                                  )
                              : const SizedBox(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
