import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';
import 'package:graduation/features/home/ui/widgets/shimmer_grid_posts_cars.dart';

class HomeBlocBuilder extends StatelessWidget {
  const HomeBlocBuilder({super.key});

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
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        childAspectRatio: 0.8,
      ),
      itemCount: carInformation.length,
      itemBuilder: (context, index) {
        final carList = carInformation[index];
        return BuildItemPostsCars(carList: carList);
      },
    );
  }
}
// class HomeBlocBuilder extends StatelessWidget {
//   const HomeBlocBuilder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (context, state) {
//         return state.when(
//           initial: () => ShimmerGridPostsCars(),
//           loading: () => ShimmerGridPostsCars(),
//           success: (carInformation) => buildGridView(carInformation),
//           error: (error) => Center(child: Text("❌ خطأ: $error")),
//         );
//       },
//     );
//   }

//   buildGridView(List<PostCar> carInformation) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(12),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 1,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: carInformation.length,
//       itemBuilder: (context, index) {
//         final carList = carInformation[index];
//         return BuildItemPostsCars(carList: carList);
//       },
//     );
//   }
// }
