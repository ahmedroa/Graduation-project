import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/build%D9%80shimmer_effect.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class ReportVehicleLocationInformation extends StatelessWidget {
  const ReportVehicleLocationInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return buildShimmerEffect();
                } else {
                  return buildShimmerEffect();
                  // return _buildLocationFields();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
