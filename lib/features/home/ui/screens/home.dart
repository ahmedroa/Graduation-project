import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/home/ui/widgets/add_post_bottom_sheet.dart';
import 'package:graduation/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedTag = 0;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<DocumentSnapshot> allCars = [];
  bool isLoading = false;
  bool isSearchActive = false;

  final List<String> _tags = ["السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];

  @override
  void initState() {
    super.initState();
    loadAllCars();
  }

  Future<void> loadAllCars() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();
      setState(() {
        allCars = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cars: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<DocumentSnapshot> getFilteredCars() {
    if (searchQuery.isEmpty) {
      return allCars;
    }

    String query = searchQuery.toLowerCase();

    return allCars.where((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['name']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['typeCar']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['model']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['plateNumber']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['city']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['neighborhood']?.toString().toLowerCase() ?? '').contains(query);
    }).toList();
  }

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTag = index;
          isSearchActive = false;
          searchQuery = "";
          searchController.clear();
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

  Widget _buildSearchResults() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<DocumentSnapshot> filteredCars = getFilteredCars();

    if (filteredCars.isEmpty) {
      return const Center(child: Text("لا توجد نتائج"));
    }

    return ListView.builder(
      itemCount: filteredCars.length,
      itemBuilder: (context, index) {
        var car = filteredCars[index].data() as Map<String, dynamic>;
        return ListTile(
          leading:
              car['image'] != null
                  ? Image.network(car['image'], width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.directions_car, size: 50),
          title: Text(car['name'] ?? "اسم غير متوفر"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${car['typeCar'] ?? "نوع غير معروف"} - ${car['model'] ?? ""}"),
              Text("${car['city'] ?? ""} - ${car['plateNumber'] ?? ""}"),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (isSearchActive) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            setState(() {
              isSearchActive = false;
              searchController.clear();
              searchQuery = "";
            });
          },
        ),
        title: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: const InputDecoration(hintText: "ابحث عن سيارة...", border: InputBorder.none),
          style: const TextStyle(color: Colors.black),
        ),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Text('أهلا آحمد', style: TextStyle(color: Colors.black, fontSize: 20)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  isSearchActive = true;
                });
              },
            ),
            const Icon(Icons.notifications, color: Colors.black),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(),
      child: Scaffold(
        appBar: _buildAppBar(),
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
        body: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child:
                  isSearchActive
                      ? _buildSearchResults()
                      : Column(
                        children: [
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
                          const SizedBox(height: 12),
                          const Flexible(child: HomeBlocBuilderWrapper()),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class HomeBlocBuilderWrapper extends StatelessWidget {
  const HomeBlocBuilderWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBlocBuilder(); // تأكد أنها مبنية صح داخل مشروعك
  }
}

// // import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
// class Homescreen extends StatefulWidget {
//   const Homescreen({super.key});

//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }

// class _HomescreenState extends State<Homescreen> {
//   int selectedTag = 0;
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";
//   List<DocumentSnapshot> allCars = [];
//   bool isLoading = false;
//   bool isSearchActive = false;

//   final List<String> _tags = ["السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];

//   @override
//   void initState() {
//     super.initState();
//     loadAllCars();
//   }

//   Future<void> loadAllCars() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();
//       setState(() {
//         allCars = snapshot.docs;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading cars: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   List<DocumentSnapshot> getFilteredCars() {
//     if (searchQuery.isEmpty) {
//       return allCars;
//     }

//     String query = searchQuery.toLowerCase();

//     return allCars.where((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       return (data['name']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['typeCar']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['model']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['plateNumber']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['city']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['neighborhood']?.toString().toLowerCase() ?? '').contains(query);
//     }).toList();
//   }

//   Widget _buildTags(int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTag = index;
//           isSearchActive = false;
//           searchQuery = "";
//           searchController.clear();
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primaryContainer,
//           borderRadius: BorderRadius.circular(15),
//           border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
//         ),
//         child: Text(_tags[index], style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary)),
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }

//     List<DocumentSnapshot> filteredCars = getFilteredCars();

//     if (filteredCars.isEmpty) {
//       return Center(child: Text("لا توجد نتائج"));
//     }

//     return ListView.builder(
//       itemCount: filteredCars.length,
//       itemBuilder: (context, index) {
//         var car = filteredCars[index].data() as Map<String, dynamic>;
//         return ListTile(
//           leading:
//               car['image'] != null
//                   ? Image.network(car['image'], width: 50, height: 50, fit: BoxFit.cover)
//                   : Icon(Icons.directions_car, size: 50),
//           title: Text(car['name'] ?? "اسم غير متوفر"),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("${car['typeCar'] ?? "نوع غير معروف"} - ${car['model'] ?? ""}"),
//               Text("${car['city'] ?? ""} - ${car['plateNumber'] ?? ""}"),
//             ],
//           ),
//           onTap: () {},
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PostsCubit(),
//       child: Scaffold(
//         backgroundColor: ColorsManager.backgroundColor,
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: ColorsManager.kPrimaryColor,
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (context) => AddPostBottomSheet(),
//             );
//           },
//           child: const Icon(Icons.add, color: Colors.white),
//         ),

//         body: SafeArea(
//           child: Column(
//             children: [
//               // Header section
//               SizedBox(
//                 height: 70,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 12, right: 12),
//                   child: Row(
//                     children: [
//                       CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
//                       horizontalSpace(12),
//                       Text('أهلا آحمد', style: TextStyles.font16BlacMedium.copyWith(fontSize: 20)),
//                       Spacer(),
//                       Icon(Icons.notifications),
//                     ],
//                   ),
//                 ),
//               ),
//               verticalSpace(12),

//               // Search field
//               Padding(
//                 padding: const EdgeInsets.only(left: 12, right: 12),
//                 child: AppTextFormField(
//                   hintText: 'بحث',
//                   validator: (value) {
//                     return null;
//                   },
//                   controller: searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value;
//                       isSearchActive = value.isNotEmpty;
//                     });
//                   },
//                   onTap: () {
//                     setState(() {
//                       isSearchActive = true;
//                     });
//                   },
//                   fillColor: Colors.white,
//                   prefixIcon: Icon(Icons.search),
//                 ),
//               ),
//               verticalSpace(12),

//               // Main content area - uses Expanded only once
//               Expanded(
//                 child:
//                     isSearchActive
//                         ? _buildSearchResults()
//                         : Column(
//                           children: [
//                             // Tags
//                             Center(
//                               child: SizedBox(
//                                 height: 40,
//                                 child: Directionality(
//                                   textDirection: TextDirection.rtl,
//                                   child: ListView(
//                                     scrollDirection: Axis.horizontal,
//                                     children: _tags.asMap().entries.map((MapEntry map) => _buildTags(map.key)).toList(),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Home content - using Flexible instead of Expanded
//                             Flexible(child: HomeBlocBuilderWrapper()),
//                           ],
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }

// // كلاس مساعد لتجنب مشكلة Expanded المتداخلة
// class HomeBlocBuilderWrapper extends StatelessWidget {
//   const HomeBlocBuilderWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return HomeBlocBuilder();
//   }
// }
// class Homescreen extends StatefulWidget {
//   const Homescreen({super.key});

//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }

// class _HomescreenState extends State<Homescreen> {
//   int selectedTag = 0;

//   final List<String> _tags = ["السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];

//   Widget _buildTags(int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTag = index;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primaryContainer,
//           borderRadius: BorderRadius.circular(15),
//           border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
//         ),
//         child: Text(_tags[index], style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary)),
//       ),
//     );
//   }

//   int currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PostsCubit(),
//       child: Scaffold(
//         backgroundColor: ColorsManager.backgroundColor,
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: ColorsManager.kPrimaryColor,
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (context) => AddPostBottomSheet(),
//             );
//           },
//           child: const Icon(Icons.add, color: Colors.white),
//         ),

//         body: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 70,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 12, right: 12),
//                   child: Row(
//                     children: [
//                       CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
//                       horizontalSpace(12),
//                       Text('أهلا آحمد', style: TextStyles.font16BlacMedium.copyWith(fontSize: 20)),
//                       Spacer(),
//                       Icon(Icons.notifications),
//                     ],
//                   ),
//                 ),
//               ),
//               verticalSpace(12),
//               Padding(
//                 padding: const EdgeInsets.only(left: 12, right: 12),
//                 child: AppTextFormField(
//                   hintText: 'بحث',
//                   validator: (value) {
//                     return null;
//                   },
//                   onChanged: (value) {},
//                   fillColor: Colors.white,
//                   prefixIcon: Icon(Icons.search),
//                 ),
//               ),
//               verticalSpace(12),
//               Center(
//                 child: SizedBox(
//                   height: 40,
//                   child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: _tags.asMap().entries.map((MapEntry map) => _buildTags(map.key)).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//               HomeBlocBuilder(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
