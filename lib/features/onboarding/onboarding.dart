import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/onboarding/onboarding_content.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  final int totalPages = 3;

  // استخدام متحكم واحد فقط للحركة لتجنب المشاكل
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // تهيئة متحكم الحركة بمدة معقولة
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    // تشغيل الحركة مباشرة
    _animationController.forward();

    // الاستماع لتغيرات الصفحة
    _pageController.addListener(() {
      // إعادة تشغيل الحركة عند تغيير الصفحة
      if (_pageController.page == _pageController.page?.round()) {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Hero(
                tag: "logo",
                child: SvgPicture.asset('img/logo.svg', width: 50, height: 50, color: ColorsManager.kPrimaryColor),
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  children: const [
                    OnboardingContent(
                      title: 'أبلغ عن سيارتك المفقودة',
                      subtitle: 'قم بإدخال تفاصيل سيارتك المفقودة ، وسنساعدك في البحث عنها.',
                      image: 'img/error.png',
                    ),
                    OnboardingContent(
                      title: 'ساهم في العثور على سيارات الآخرين',
                      subtitle:
                          'إذا لاحظت سيارة مشبوهة، قم برفع صورها وتحديد موقعها، فقد تكون السيارة مفقودة ويبحث عنها صاحبها.',
                      image: 'img/error.png',
                    ),
                    OnboardingContent(
                      title: 'ساهم في العثور على سيارات الآخرين',
                      subtitle:
                          'إذا لاحظت سيارة مشبوهة، قم برفع صورها وتحديد موقعها، فقد تكون السيارة مفقودة ويبحث عنها صاحبها.',
                      image: 'img/error.png',
                    ),
                  
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = index;
                        _pageController.animateToPage(
                          currentPage,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      width: currentPage == index ? 20 : 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          currentPage == index ? const Radius.circular(8) : const Radius.circular(20),
                        ),
                        color: currentPage == index ? ColorsManager.kPrimaryColor : ColorsManager.gray,
                      ),
                    ),
                  );
                }),
              ),
              verticalSpace(40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child:
                          currentPage == totalPages - 1
                              ? MainButton(
                                key: const ValueKey('login'),
                                text: 'تسجيل الدخول',
                                onTap: () {
                                  context.pushNamed(Routes.loginScreen);
                                },
                                width: 130,
                                int: 20,
                              )
                              : Container(
                                key: const ValueKey('next'),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: ColorsManager.kPrimaryColor,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward, color: ColorsManager.white),
                                ),
                              ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushNamed(Routes.loginScreen);
                      },
                      child: const Text('تخطي', style: TextStyle(fontSize: 16, color: ColorsManager.kPrimaryColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
