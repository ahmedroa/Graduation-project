import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
// import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManager.kPrimaryColor,
          onPressed: () {
            BlocProvider.of<PostsCubit>(context).createPost();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('الرئيسية'),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications, color: ColorsManager.kPrimaryColor))],
        ),
        body: HomeBlocBuilder(),
      ),
    );
  }
}
