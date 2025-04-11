import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/ui/screens/build_search_result_item.dart';
import 'package:graduation/features/home/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/home/ui/widgets/home_bloc_builder.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedTag = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTag = index;
        });
        context.read<HomeCubit>().getHomeData(tagIndex: index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
          border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
        ),
        child: Text(
          context.read<HomeCubit>().tags[index],
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubitState = context.watch<HomeCubit>().state;
    final isSearching = cubitState.isSearching;
    final searchResults = cubitState.searchResults;
    final isLoading = cubitState.isLoading;

    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar:
          isSearching
              ? AppBar(
                backgroundColor: ColorsManager.backgroundColor,
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
          showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => AddPostBottomSheet());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children:
              isSearching
                  ? [
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : searchResults.isEmpty && _searchController.text.isNotEmpty
                        ? Expanded(child: Center(child: Text('لا توجد نتائج', style: TextStyle(fontSize: 18))))
                        : Expanded(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return BuildSearchResultItem(doc: searchResults[index], onTap: () {});
                            },
                          ),
                        ),
                  ]
                  : [
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
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
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
                            children:
                                context
                                    .read<HomeCubit>()
                                    .tags
                                    .asMap()
                                    .entries
                                    .map((MapEntry map) => _buildTags(map.key))
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: HomeBlocBuilder()),
                  ],
        ),
      ),
    );
  }
}
