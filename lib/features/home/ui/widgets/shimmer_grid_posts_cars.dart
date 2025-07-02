import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridPostsCars extends StatelessWidget {
  const ShimmerGridPostsCars({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerPostsCars(),
    );
  }
}

class BuildHomeGridView extends StatelessWidget {
  final int crossAxisCount;
  final double aspectRatio;
  final HomeState state;
  final ScrollController? scrollController;

  const BuildHomeGridView({
    super.key,
    required this.crossAxisCount,
    required this.aspectRatio,
    required this.state,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> itemsToShow = state.isSearching ? state.searchResults : state.carInformation;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeCubit>().refreshData();
      },
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: itemsToShow.length,
        itemBuilder: (context, index) {
          if (state.isSearching) {
            final doc = itemsToShow[index] as QueryDocumentSnapshot;
            final carData = PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            return BuildItemPostsCars(carList: carData);
          } else {
            final car = itemsToShow[index] as PostCar;
            return BuildItemPostsCars(carList: car);
          }
        },
      ),
    );
  }
}

class ShimmerPostsCars extends StatelessWidget {
  const ShimmerPostsCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: .1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: double.infinity, height: 140, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(width: double.infinity, height: 14, color: Colors.white),
                        ),
                      ),
                      horizontalSpace(16),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(width: 40.w, height: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(width: double.infinity, height: 12, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const Icon(Icons.location_on_outlined, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(width: 60, height: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
