import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/home/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
// import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedTag = 0;

  final List<String> _tags = ["السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTag = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
          border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
        ),
        child: Text(_tags[index], style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary)),
      ),
    );
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(),
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManager.kPrimaryColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => AddPostBottomSheet(),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),

        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
                      horizontalSpace(12),
                      Text('أهلا آحمد', style: TextStyles.font16BlacMedium.copyWith(fontSize: 20)),
                      Spacer(),
                      Icon(Icons.notifications),
                    ],
                  ),
                ),
              ),
              verticalSpace(12),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: AppTextFormField(
                  hintText: 'بحث',
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {},
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              verticalSpace(12),
              Center(
                child: SizedBox(
                  height: 40,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _tags.asMap().entries.map((MapEntry map) => _buildTags(map.key)).toList(),
                    ),
                  ),
                ),
              ),
              HomeBlocBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
