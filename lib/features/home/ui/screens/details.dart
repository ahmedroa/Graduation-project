// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Details extends StatefulWidget {
  final PostCar? carList;
  const Details({super.key, this.carList});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late PageController pageController;
  bool isLiked = false;
  bool isLoading = true;
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    if (widget.carList == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final liked = await _homeCubit.checkIfCarLiked(widget.carList!.id);
    setState(() {
      isLiked = liked;
      isLoading = false;
    });
  }

  Future<void> _toggleLike() async {
    if (widget.carList == null) return;

    final userId = _homeCubit.getCurrentUserId();
    if (userId == null) {
      notRegistered(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    // محاولة تبديل حالة الإعجاب
    final success = await _homeCubit.toggleLike(widget.carList!);

    // تحديث حالة الإعجاب المحلية بعد التبديل إذا نجحت العملية
    if (success) {
      final newLikeStatus = await _homeCubit.checkIfCarLiked(widget.carList!.id);
      setState(() {
        isLiked = newLikeStatus;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildImage(pageController, context),
          verticalSpace(24),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.carList?.name ?? "اسم غير متوفر", style: TextStyles.font16BlacMedium),
                    // زر الإعجاب
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: ColorsManager.kPrimaryColor),
                        )
                        : IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 28,
                          ),
                          onPressed: _toggleLike,
                        ),
                  ],
                ),
                Text(widget.carList?.description ?? "وصف غير متوفر", style: TextStyles.font14GrayMedium),
                SizedBox(height: 16),
                Container(
                  height: 80,
                  decoration: BoxDecoration(color: ColorsManager.grayBorder, borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [Icon(Icons.person, color: ColorsManager.kPrimaryColor), horizontalSpace(20)]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildImage(PageController pageController, BuildContext context) {
    // Same as your original code
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.carList?.images.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius:
                      index == (widget.carList?.images.length ?? 0) - 1
                          ? BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                          : BorderRadius.zero,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 4), blurRadius: 8)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(index == (widget.carList?.images.length ?? 0) - 1 ? 20 : 0),
                    bottomRight: Radius.circular(index == (widget.carList?.images.length ?? 0) - 1 ? 20 : 0),
                  ),
                  child: Image.network(
                    widget.carList?.images[index] ?? '',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[300], child: Icon(Icons.error, color: Colors.red));
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          if (widget.carList?.images.length != null && widget.carList!.images.length > 1)
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: SmoothPageIndicator(
                controller: pageController,
                count: widget.carList!.images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
