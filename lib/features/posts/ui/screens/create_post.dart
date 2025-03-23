import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/cubit/posts_cubit.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('رفع بلاغ'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalSpace(80),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: '3 ', style: TextStyles.font13BlueSemiBold.copyWith(fontSize: 24)),
                    TextSpan(
                      text: 'خطوات سهلة',
                      style: TextStyles.font24BlueBold.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              verticalSpace(20),
              Text(
                'لرفع بلاغ سيارتك',
                style: TextStyles.font16DarkRegular.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              verticalSpace(40),
              _buildStep(
                context: context, 
                int: 1, 
                title: 'معلومات السيارة', 
                supTitle: '6 مراحل', 
                icon: Icon(Icons.directions_car),
                onTap: () => _navigateToStep(context, 1),
              ),
              verticalSpace(20),
              _buildStep(
                context: context, 
                int: 2, 
                title: 'معلومات الموقع', 
                supTitle: '3 مراحل', 
                icon: Icon(Icons.location_on),
                onTap: () => _navigateToStep(context, 2),
              ),
              verticalSpace(20),
              _buildStep(
                context: context, 
                int: 3, 
                title: 'معلومات التواصل', 
                supTitle: '4 مراحل', 
                icon: Icon(Icons.contact_phone),
                onTap: () => _navigateToStep(context, 3),
              ),
              verticalSpace(40),
              const Spacer(),
              MainButton(
                text: 'البدء',
                onTap: () => _navigateToStep(context, 1),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required int int,
    required String title,
    required String supTitle,
    required Icon icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsManager.gray, width: 0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Center(
                  child: Text(
                    '$int',
                    style: TextStyles.font12WhiteMediuAm.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: icon,
                  ),
                  verticalSpace(5),
                  Text(
                    title,
                    style: TextStyles.font14DarkMedium.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(supTitle, style: TextStyles.font12greyMedium),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStep(BuildContext context, int step) {
    final postsCubit = context.read<PostsCubit>();
    postsCubit.selectOption(step);
    context.pushNamed(Routes.carInformation);
  }
}
