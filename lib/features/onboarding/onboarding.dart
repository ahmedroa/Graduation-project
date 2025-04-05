import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Hero(
          tag: "logo",
          child: Padding(
            padding: const EdgeInsets.all(80),
            child: SvgPicture.asset('img/logo.svg', width: 100, height: 100),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                      // إعادة تشغيل الحركة
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
                      image: 'img/error.jpg',
                    ),
                    OnboardingContent(
                      title: 'ساهم في العثور على سيارات الآخرين',
                      subtitle:
                          'إذا لاحظت سيارة مشبوهة، قم برفع صورها وتحديد موقعها، فقد تكون السيارة مفقودة ويبحث عنها صاحبها.',
                      image: 'img/error.jpg',
                    ),
                    OnboardingContent(
                      title: 'راقب أرباح سكنك',
                      subtitle: 'يمكنك متابعة الأرباح وإنشاء التقارير للسكن بكل سرعة وسهولة ',
                      image: 'img/error.jpg',
                    ),
                  ],
                ),
              ),

              // مؤشرات الصفحات مع حركة انتقالية
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

              // أزرار التنقل مع الحفاظ على نفس الحركة الانتقالية للزر
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
                                onTap: () {},
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
                      onPressed: () {},
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

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.title, required this.subtitle, required this.image});
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    // استخدام AnimatedOpacity بدلاً من Opacity مع AnimatedBuilder
    return Column(
      children: [
        // الصورة مع حركة بسيطة
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value, // تدرج الشفافية من 0 إلى 1
                child: Transform.scale(
                  scale: 0.8 + (value * 0.2), // نمو من 80% إلى 100%
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.6,
                  colors: [ColorsManager.kPrimaryColor.withOpacity(0.4), Colors.white.withOpacity(0)],
                ),
              ),
              child: Image.asset(image),
            ),
          ),
        ),

        // العنوان والوصف بحركات بسيطة
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // حركة انزلاق للعنوان
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
                  );
                },
                child: Text(title, style: TextStyles.font30BlackBold, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 20),
              // حركة ظهور للوصف
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                // تأخير بسيط لظهور الوصف بعد العنوان
                builder: (context, value, child) {
                  // تأكد من أن قيمة الشفافية دائمًا بين 0 و 1
                  double opacity = value.clamp(0.0, 1.0);
                  return Opacity(opacity: opacity, child: child);
                },
                child: Text(subtitle, style: TextStyles.font16DarkRegular, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
