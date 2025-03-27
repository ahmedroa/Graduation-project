import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/widgets/loading.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/ui/widgets/build_item_posts_cars.dart';

class HomeBlocBuilder extends StatelessWidget {
  const HomeBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.when(
          initial: () => loading(),
          loading: () => loading(),
          success:
              (carInformation) => Expanded(
                child: ListView.builder(
                  itemCount: carInformation.length,
                  itemBuilder: (context, index) {
                    final carList = carInformation[index];
                    return BuildItemPostsCars(carList: carList);
                  },
                ),
              ),
          error: (error) => Center(child: Text("❌ خطأ: $error")),
        );
      },
    );
  }
}
