import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/ui/widgets/shimmer_grid_posts_cars.dart';
import 'package:graduation/features/reported_cars/ui/widgets/no_data_widget.dart';

class HomeBlocBuilder extends StatefulWidget {
  const HomeBlocBuilder({super.key});

  @override
  State<HomeBlocBuilder> createState() => _HomeBlocBuilderState();
}

class _HomeBlocBuilderState extends State<HomeBlocBuilder> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<HomeCubit>();
      final state = cubit.state;
      if (!state.isLoadingMore && state.hasMoreData && !state.isSearching) {
        cubit.loadMoreData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading && state.carInformation.isEmpty) {
          return ShimmerGridPostsCars();
        } else if (state.error != null && state.carInformation.isEmpty) {
          return NoDataWidget(message: 'حدث خطأ أثناء تحميل البيانات');
        } else if (state.carInformation.isEmpty && !state.isLoading) {
          return NoDataWidget(message: 'لا توجد بيانات متاحة حالياً');
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = MediaQuery.of(context).size.width;
              final bool isTablet = screenWidth > 600;
              int crossAxisCount = isTablet ? 3 : 2;
              double aspectRatio = isTablet ? 0.75 : 0.68;

              return Column(
                children: [
                  Expanded(
                    child: BuildHomeGridView(
                      crossAxisCount: crossAxisCount,
                      aspectRatio: aspectRatio,
                      state: state,
                      scrollController: _scrollController,
                    ),
                  ),
                  if (state.isLoadingMore)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.kPrimaryColor),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'جاري تحميل المزيد من البيانات...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // No more data indicator
                  // if (!state.hasMoreData && state.carInformation.isNotEmpty && !state.isSearching)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     child: Text(
                  //       'تم عرض جميع البيانات',
                  //       style: TextStyle(
                  //         fontSize: 14,
                  //         color: Colors.grey[600],
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ),
                ],
              );
            },
          );
        }
      },
    );
  }
}

