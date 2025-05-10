import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/cubit/home_state.dart';
import 'package:graduation/features/home/search%20/build_search_result_item.dart';
import 'package:graduation/features/home/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:graduation/features/home/search%20/shimmer_loding_search.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
  int selectedTag = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // إضافة متحكم الأنيميشن
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // متغير للتحكم في ظهور البيانات الجديدة عند تغيير التصنيف
  bool _isChangingFilter = false;

  @override
  void initState() {
    super.initState();

    // إعداد متحكم الأنيميشن
    _animationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    // إنشاء أنواع مختلفة من الأنيميشن
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart));

    _animationController.forward();

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && !context.read<HomeCubit>().state.isSearching) {
        context.read<HomeCubit>().startSearch();
      }
    });

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        context.read<HomeCubit>().performSearch(_searchController.text);
      } else {
        context.read<HomeCubit>().performSearch("");
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubitState = context.watch<HomeCubit>().state;
    final isSearching = cubitState.isSearching;
    final searchResults = cubitState.searchResults;
    final isLoading = cubitState.isLoading;

    // نحتفظ بتتبع حالة تغيير الفلتر فقط بدون إعادة تشغيل كامل أنيميشن الصفحة
    if (cubitState.isLoading) {
      _isChangingFilter = true;
    } else if (_isChangingFilter && !cubitState.isLoading) {
      _isChangingFilter = false;
      // لا نقوم بإعادة تشغيل _animationController هنا لأننا نريد فقط أنيميشن العناصر
    }

    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar:
          isSearching
              ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<HomeCubit>().stopSearch();
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
                title: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(hintText: "بحث", border: InputBorder.none),
                  textDirection: TextDirection.rtl,
                ),
              )
              : null,
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(scale: 0.5 + (_animationController.value * 0.5), child: child);
        },
        child: FloatingActionButton(
          backgroundColor: ColorsManager.kPrimaryColor,
          onPressed: () {
            context.isNotLoggedIn
                ? notRegistered(context)
                : showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => AddPostBottomSheet(),
                );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(children: isSearching ? _buildSearchContent(isLoading, searchResults) : _buildHomeContent()),
      ),
    );
  }

  List<Widget> _buildSearchContent(bool isLoading, List<dynamic> searchResults) {
    return [
      isLoading
          ? ShimmerLodingSearch()
          : searchResults.isEmpty && _searchController.text.isNotEmpty
          ? Expanded(child: Center(child: Text('لا توجد نتائج', style: TextStyle(fontSize: 18))))
          : Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(bottom: 8),
                    transform: Matrix4.translationValues(0, 0, 0),
                    child: BuildSearchResultItem(doc: searchResults[index], onTap: () {}),
                  ),
                );
              },
            ),
          ),
    ];
  }

  List<Widget> _buildHomeContent() {
    return [
      // الترويسة - نشغل الأنيميشن فقط عند فتح الصفحة أول مرة
      _animationController.status == AnimationStatus.forward
          ? FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(position: _slideAnimation, child: _buildHeader()),
          )
          : _buildHeader(),
      verticalSpace(12),

      // حقل البحث - نشغل الأنيميشن فقط عند فتح الصفحة أول مرة
      _animationController.status == AnimationStatus.forward
          ? FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(position: _slideAnimation, child: _buildSearchField()),
          )
          : _buildSearchField(),
      verticalSpace(12),

      // التصنيفات - نشغل الأنيميشن فقط عند فتح الصفحة أول مرة
      _animationController.status == AnimationStatus.forward
          ? FadeTransition(
            opacity: _fadeAnimation,
            child: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(offset: Offset(0, 20 * (1 - _animationController.value)), child: child);
                  },
                  child: _buildTagsList(),
                );
              },
            ),
          )
          : _buildTagsList(),

      // نعرض قائمة العناصر دائماً مع الأنيميشن سواء عند فتح الصفحة أو عند تغيير الفلتر
      Expanded(child: HomeBlocBuilder(controller: _animationController, isChangingFilter: _isChangingFilter)),
    ];
  }

  // تقسيم الواجهة إلى أجزاء منفصلة للمرونة
  Widget _buildHeader() {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: ColorsManager.kPrimaryColor)),
            horizontalSpace(12),
            Text('أهلا آحمد', style: TextStyles.font16BlacMedium.copyWith(fontSize: 20)),
            Spacer(),
            Icon(Icons.notifications, color: ColorsManager.kPrimaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: GestureDetector(
        onTap: () {
          context.read<HomeCubit>().startSearch();
          _searchFocusNode.requestFocus();
        },
        child: AbsorbPointer(
          child: AppTextFormField(
            hintText: 'بحث',
            validator: (value) {
              return null;
            },
            onChanged: (value) {},
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.search, color: ColorsManager.kPrimaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsList() {
    return Center(
      child: SizedBox(
        height: 40,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children:
                context
                    .read<HomeCubit>()
                    .tags
                    .asMap()
                    .entries
                    .map((MapEntry map) => _buildTagWithAnimation(map.key))
                    .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTagWithAnimation(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double safeDelay = 0.2 + (index * 0.1).clamp(0.0, 0.7);
        final curvedValue = Curves.easeOutBack.transform(
          Interval(safeDelay, 1.0).transform(_animationController.value),
        );

        final double safeOpacity = curvedValue.clamp(0.0, 1.0);

        return Opacity(
          opacity: safeOpacity,
          child: Transform.translate(offset: Offset(50 * (1 - safeOpacity), 0), child: child),
        );
      },
      child: _buildTags(index),
    );
  }

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        // تجنب إعادة بناء الواجهة إذا تم اختيار نفس التصنيف
        if (selectedTag != index) {
          setState(() {
            selectedTag = index;
            // تعيين المتغير لإشارة بدء تغيير التصنيف
            _isChangingFilter = true;
          });
          context.read<HomeCubit>().getHomeData(tagIndex: index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border:
              selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor.withOpacity(.6), width: 3) : null,
        ),
        child: Text(
          context.read<HomeCubit>().tags[index],
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
