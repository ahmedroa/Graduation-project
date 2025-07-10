// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/cubit/details_cubit.dart';
import 'package:graduation/features/details/ui/widgets/build_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/features/details/ui/widgets/car_information.dart';
import 'package:graduation/features/details/ui/widgets/comments/comments_section.dart';
import 'package:graduation/features/details/ui/widgets/person_Information.dart';

class Details extends StatefulWidget {
  final PostCar? carList;
  const Details({super.key, this.carList});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late PageController pageController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.carList?.id != null) {
        context.read<DetailsCubit>().checkIfCarLiked(widget.carList!.id);
        context.read<DetailsCubit>().getLastThreeComments(widget.carList!.id!);
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: BlocListener<DetailsCubit, DetailsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
            context.read<DetailsCubit>().clearError();
          }
        },
        child: ListView(
          children: [
            BuildImagesCar(pageController: pageController, widget: widget),
            CarInformationWidget(widget: widget),
            verticalSpace(20),
            if (widget.carList?.nameOwner != null && widget.carList!.nameOwner!.isNotEmpty)
              PersonInformation(widget: widget),
            verticalSpace(20),
            if (widget.carList?.description != null && widget.carList!.description!.isNotEmpty) description(),
            verticalSpace(20),
            Comments(commentController: _commentController, widget: widget),

            TextButton(
              onPressed: () {
                context.pushReplacementNamed(Routes.reportContentScreen, arguments: widget.carList?.id ?? '');
              },
              child: Text(
                'الإبلاغ عن محتوى',
                style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.kPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container description() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('وصف', style: TextStyles.font16DarkBold),
            verticalSpace(8),
            Text(widget.carList?.description ?? "وصف غير متوفر", style: TextStyles.font14DarkRegular),
          ],
        ),
      ),
    );
  }
}
