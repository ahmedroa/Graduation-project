import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/not_registered.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/search%20/build_search_result_item.dart';
import 'package:graduation/features/posts/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:graduation/features/home/search%20/shimmer_loding_search.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedTag = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isChangingFilter = false;

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubitState = context.watch<HomeCubit>().state;
    final isSearching = cubitState.isSearching;
    final searchResults = cubitState.searchResults;
    final isLoading = cubitState.isLoading;

    if (cubitState.isLoading) {
      _isChangingFilter = true;
    } else if (_isChangingFilter && !cubitState.isLoading) {
      _isChangingFilter = false;
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
      floatingActionButton: FloatingActionButton(
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
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: BuildSearchResultItem(doc: searchResults[index], onTap: () {}),
                );
              },
            ),
          ),
    ];
  }

  List<Widget> _buildHomeContent() {
    return [
      _buildHeader(),
      verticalSpace(12),

      _buildSearchField(),
      verticalSpace(12),

      _buildTagsList(),

      Expanded(child: HomeBlocBuilder()),
    ];
  }

  Widget _buildHeader() {
    return SizedBox(
      // height: 70,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                context.isNotLoggedIn ? notRegistered(context) : context.pushNamed(Routes.profile);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: ColorsManager.kPrimaryColor),
              ),
            ),
            horizontalSpace(12),
            // Spacer(),
            // Icon(Icons.notifications, color: ColorsManager.kPrimaryColor),
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
                context.read<HomeCubit>().tags.asMap().entries.map((MapEntry map) => _buildTags(map.key)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        if (selectedTag != index) {
          setState(() {
            selectedTag = index;
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
