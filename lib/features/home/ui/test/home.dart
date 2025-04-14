

// class Details extends StatefulWidget {
//   final PostCar? carList;
//   const Details({super.key, this.carList});

//   @override
//   State<Details> createState() => _DetailsState();
// }

// class _DetailsState extends State<Details> {
//   late PageController pageController;
//   bool isLiked = false;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//     checkIfLiked();
//   }

//   // Check if the current user has liked this post
//   Future<void> checkIfLiked() async {
//     try {
//       final currentUser = 'XCEcZ6CcraVPsP4nMRGVVxQ4Oyl2';
//       if (widget.carList == null) {
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       final docSnapshot =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc('XCEcZ6CcraVPsP4nMRGVVxQ4Oyl2')
//               .collection('liked_cars')
//               .doc(widget.carList!.id)
//               .get();

//       setState(() {
//         isLiked = docSnapshot.exists;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error checking like status: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Toggle like status in Firestore
//   Future<void> toggleLike() async {
//     try {
//       final currentUser = 'XCEcZ6CcraVPsP4nMRGVVxQ4Oyl2';
//       if (widget.carList == null) return;

//       final userLikesRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc('XCEcZ6CcraVPsP4nMRGVVxQ4Oyl2')
//           .collection('liked_cars');

//       setState(() {
//         isLoading = true;
//       });

//       if (isLiked) {
//         // Remove like
//         await userLikesRef.doc(widget.carList!.id).delete();
//       } else {
//         // Add like
//         await userLikesRef.doc(widget.carList!.id).set({
//           'carId': widget.carList!.id,
//           'likedAt': FieldValue.serverTimestamp(),
//           'carName': widget.carList!.name,
//           'carImage': widget.carList!.images.isNotEmpty ? widget.carList!.images[0] : null,
//           'carDescription': widget.carList!.description,
//         });
//       }

//       // Update car's likes count in the main collection (optional)
//       final carRef = FirebaseFirestore.instance.collection('cars').doc(widget.carList!.id);
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         final carDoc = await transaction.get(carRef);
//         if (carDoc.exists) {
//           int currentLikes = carDoc.data()?['likesCount'] ?? 0;
//           transaction.update(carRef, {'likesCount': isLiked ? currentLikes - 1 : currentLikes + 1});
//         }
//       });

//       setState(() {
//         isLiked = !isLiked;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error toggling like: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           buildImage(pageController, context),
//           verticalSpace(24),
//           Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(widget.carList?.name ?? "اسم غير متوفر", style: TextStyles.font16BlacMedium),
//                     // Like button
//                     isLoading
//                         ? SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: ColorsManager.kPrimaryColor),
//                         )
//                         : IconButton(
//                           icon: Icon(
//                             isLiked ? Icons.favorite : Icons.favorite_border,
//                             color: isLiked ? Colors.red : Colors.grey,
//                             size: 28,
//                           ),
//                           onPressed: toggleLike,
//                         ),
//                   ],
//                 ),
//                 Text(widget.carList?.description ?? "وصف غير متوفر", style: TextStyles.font14GrayMedium),
//                 SizedBox(height: 16),
//                 Container(
//                   height: 80,
//                   decoration: BoxDecoration(color: ColorsManager.grayBorder, borderRadius: BorderRadius.circular(20)),
//                   child: Row(children: [Icon(Icons.person, color: ColorsManager.kPrimaryColor), horizontalSpace(20)]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   SizedBox buildImage(PageController pageController, BuildContext context) {
//     return SizedBox(
//       height: 400,
//       child: Stack(
//         children: [
//           PageView.builder(
//             controller: pageController,
//             itemCount: widget.carList?.images.length ?? 0,
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius:
//                       index == (widget.carList?.images.length ?? 0) - 1
//                           ? BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
//                           : BorderRadius.zero,
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 4), blurRadius: 8)],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(index == (widget.carList?.images.length ?? 0) - 1 ? 20 : 0),
//                     bottomRight: Radius.circular(index == (widget.carList?.images.length ?? 0) - 1 ? 20 : 0),
//                   ),
//                   child: Image.network(
//                     widget.carList?.images[index] ?? '',
//                     width: double.infinity,
//                     height: 300,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(color: Colors.grey[300], child: Icon(Icons.error, color: Colors.red));
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//           Positioned(
//             top: 40,
//             right: 16,
//             child: CircleAvatar(
//               backgroundColor: Colors.black.withOpacity(0.5),
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ),
//           if (widget.carList?.images.length != null && widget.carList!.images.length > 1)
//             Positioned(
//               bottom: 20,
//               left: MediaQuery.of(context).size.width / 2 - 30,
//               child: SmoothPageIndicator(
//                 controller: pageController,
//                 count: widget.carList!.images.length,
//                 effect: ExpandingDotsEffect(
//                   dotHeight: 8,
//                   dotWidth: 8,
//                   activeDotColor: Colors.white,
//                   dotColor: Colors.grey,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }



// class Details extends StatelessWidget {
//   final PostCar? carList;
//   const Details({super.key, this.carList});

//   @override
//   Widget build(BuildContext context) {
//     PageController pageController = PageController();
//     // final homeCunit = context.read<HomeCubit>(); 

//     return Scaffold(
//       body: Column(
//         children: [
//           buildImage(pageController, context),
//           verticalSpace(24),
//           Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(carList?.name ?? "اسم غير متوفر", style: TextStyles.font16BlacMedium),
//                 Text(carList?.description ?? "اسم غير متوفر", style: TextStyles.font14GrayMedium),

//                 Container(
//                   height: 80,
//                   decoration: BoxDecoration(color: ColorsManager.grayBorder, borderRadius: BorderRadius.circular(20)),
//                   child: Row(children: [Icon(Icons.person, color: ColorsManager.kPrimaryColor), horizontalSpace(20)]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   SizedBox buildImage(PageController pageController, BuildContext context) {
//     return SizedBox(
//       height: 400,
//       child: Stack(
//         children: [
//           PageView.builder(
//             controller: pageController,
//             itemCount: carList?.images.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius:
//                       index == carList!.images.length - 1
//                           ? BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
//                           : BorderRadius.zero, // تضيف التدوير للصورة الأخيرة فقط
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 4), blurRadius: 8)],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(index == carList!.images.length - 1 ? 20 : 0),
//                     bottomRight: Radius.circular(index == carList!.images.length - 1 ? 20 : 0),
//                   ),
//                   child: Image.network(
//                     carList?.images[index] ?? '',
//                     width: double.infinity,
//                     height: 300,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//           ),

//           Positioned(
//             top: 40,
//             right: 16,
//             child: CircleAvatar(
//               backgroundColor: Colors.black.withOpacity(0.5),
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ),

//           Positioned(
//             bottom: 20,
//             left: MediaQuery.of(context).size.width / 2 - 30,
//             child: SmoothPageIndicator(
//               controller: pageController,
//               count: carList!.images.length,
//               effect: ExpandingDotsEffect(
//                 dotHeight: 8,
//                 dotWidth: 8,
//                 activeDotColor: Colors.white,
//                 dotColor: Colors.grey,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// Future<void> toggleLike(String carId) async {
//   final user = FirebaseAuth.instance.currentUser;
//   final docRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .collection('likedCars')
//       .doc(carId);

//   final doc = await docRef.get();

//   if (doc.exists) {
//     // إذا السيارة موجودة نحذف اللايك
//     await docRef.delete();
//   } else {
//     // إذا مش موجودة نضيفها للايكات
//     await docRef.set({
//       'carId': carId,
//       'likedAt': Timestamp.now(),
//     });
//   }
// }

// Future<bool> isCarLiked(String carId) async {
//   final user = FirebaseAuth.instance.currentUser;
//   final docRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .collection('likedCars')
//       .doc(carId);

//   final doc = await docRef.get();
//   return doc.exists;
// }



// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeState.initial());
//   final List<String> tags = ['الكل', "السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   void getHomeData({int tagIndex = 0}) async {
//     try {
//       emit(HomeState.loading());

//       Query query = firestore.collection('posts');

//       // تطبيق الفلتر حسب التصنيف المختار
//       if (tagIndex == 1) {
//         // السيارات اللتي تم العثور عليها
//         query = query.where('stolen', isEqualTo: false);
//       } else if (tagIndex == 2) {
//         // السيارات المبلغ عنها
//         query = query.where('stolen', isEqualTo: true);
//       }
//       // إذا كان التصنيف "الكل" (tagIndex == 0)، لا نطبق أي فلتر إضافي

//       QuerySnapshot snapshot = await query.get();

//       List<PostCar> carList =
//           snapshot.docs.map((doc) {
//             return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//           }).toList();

//       emit(HomeState.success(carInformation: carList));
//     } catch (e) {
//       emit(HomeState.error(error: e.toString()));
//     }
//   }

// }
// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeState.initial());
//   final List<String> tags = ['الكل', "السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];
//   String selectedTag = 'الكل'; // تصنيف افتراضي
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   void selectTag(String tag) {
//     selectedTag = tag;
//     getHomeData(); // استدعاء الدالة لتحديث البيانات بناءً على التصنيف المختار
//   }

//   void getHomeData() async {
//     try {
//       emit(HomeState.loading());

//       Query query = firestore.collection('posts');

//       // تطبيق الفلتر حسب التصنيف المختار
//       if (selectedTag == "السيارات اللتي تم العثور عليها") {
//         query = query.where('foundIt', isEqualTo: false);
//       } else if (selectedTag == "السيارات المبلغ عنها") {
//         query = query.where('stolen', isEqualTo: true);
//       }
//       // إذا كان التصنيف "الكل"، لا نطبق أي فلتر إضافي

//       QuerySnapshot snapshot = await query.get();

//       List<PostCar> carList =
//           snapshot.docs.map((doc) {
//             return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//           }).toList();

//       emit(HomeState.success(carInformation: carList));
//     } catch (e) {
//       emit(HomeState.error(error: e.toString()));
//     }
//   }
// }

// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeState.initial());
//   final List<String> tags = ['الكل', "السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];

//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   void getHomeData() async {
//     try {
//       emit(HomeState.loading());
//       QuerySnapshot snapshot = await firestore.collection('posts').get();
//       List<PostCar> carList =
//           snapshot.docs.map((doc) {
//             return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//           }).toList();
//       emit(HomeState.success(carInformation: carList));
//     } catch (e) {
//       emit(HomeState.error(error: e.toString()));
//     }
//   }
// }




// @freezed
// class HomeState with _$HomeState {
//   const factory HomeState.initial() = _Initial;

//   const factory HomeState.loading() = Loading;

//   const factory HomeState.success({required List<PostCar> carInformation}) = Success;

//   const factory HomeState.error({required String error}) = Error;
// }





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
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   List<QueryDocumentSnapshot> _searchResults = [];
//   bool _isLoading = false;

//   // final List<String> _tags = ["السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<HomeCubit>().getHomeData(tagIndex: selectedTag);
//     });

//     _searchFocusNode.addListener(() {
//       // باقي الكود بدون تغيير
//     });
//     _searchFocusNode.addListener(() {
//       if (_searchFocusNode.hasFocus && !_isSearching) {
//         setState(() {
//           _isSearching = true;
//         });
//       }
//     });

//     _searchController.addListener(() {
//       if (_searchController.text.isNotEmpty) {
//         _performSearch(_searchController.text);
//       } else {
//         setState(() {
//           _searchResults = [];
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }

//   void _startSearch() {
//     setState(() {
//       _isSearching = true;
//     });
//     _searchFocusNode.requestFocus();
//   }

//   void _stopSearch() {
//     setState(() {
//       _isSearching = false;
//       _searchController.clear();
//       _searchResults = [];
//     });
//     FocusScope.of(context).unfocus();
//   }

//   Future<void> _performSearch(String query) async {
//     if (query.isEmpty) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // الحصول على جميع الوثائق من مجموعة posts
//       final QuerySnapshot postsSnapshot = await FirebaseFirestore.instance.collection('posts').get();

//       // تطبيق معايير البحث محلياً
//       final List<QueryDocumentSnapshot> filteredDocs = _filterDocuments(postsSnapshot.docs, query.toLowerCase());

//       setState(() {
//         _searchResults = filteredDocs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('حدث خطأ أثناء البحث: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   List<QueryDocumentSnapshot> _filterDocuments(List<QueryDocumentSnapshot> allCars, String query) {
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
//         });
//         // استدعاء دالة getHomeData مع تمرير الفهرس المحدد
//         context.read<HomeCubit>().getHomeData(tagIndex: index);
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//         decoration: BoxDecoration(
//           // color: Theme.of(context).colorScheme.primaryContainer,
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
//         ),
//         child: Text(
//           context.read<HomeCubit>().tags[index],
//           style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
//         ),
//       ),
//     );
//   }
//   // Widget _buildTags(int index) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       setState(() {
//   //         selectedTag = index;
//   //       });
//   //     },
//   //     child: Container(
//   //       margin: const EdgeInsets.symmetric(horizontal: 5),
//   //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//   //       decoration: BoxDecoration(
//   //         color: Theme.of(context).colorScheme.primaryContainer,
//   //         borderRadius: BorderRadius.circular(15),
//   //         border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
//   //       ),
//   //       child: Text(
//   //         context.read<HomeCubit>().tags[index],
//   //         style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // بناء عنصر نتيجة البحث
//   Widget _buildSearchResultItem(QueryDocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(12),
//         title: Text(
//           data['name'] ?? 'سيارة',
//           style: TextStyle(fontWeight: FontWeight.bold),
//           textDirection: TextDirection.rtl,
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text('النوع: ${data['typeCar'] ?? ''}', textDirection: TextDirection.rtl),
//             Text('الموديل: ${data['model'] ?? ''}', textDirection: TextDirection.rtl),
//             Text('رقم اللوحة: ${data['plateNumber'] ?? ''}', textDirection: TextDirection.rtl),
//             Text('المدينة: ${data['city'] ?? ''}', textDirection: TextDirection.rtl),
//           ],
//         ),
//         onTap: () {
//           // عند النقر على النتيجة يمكنك الانتقال إلى صفحة تفاصيل السيارة
//           // Navigator.push(...
//         },
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
//         appBar:
//             _isSearching
//                 ? AppBar(
//                   backgroundColor: ColorsManager.backgroundColor,
//                   elevation: 0,
//                   leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _stopSearch),
//                   title: TextField(
//                     controller: _searchController,
//                     focusNode: _searchFocusNode,
//                     decoration: InputDecoration(hintText: "بحث", border: InputBorder.none),
//                     textDirection: TextDirection.rtl,
//                   ),
//                 )
//                 : null,
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
//             children:
//                 _isSearching
//                     ? [
//                       // عرض نتائج البحث
//                       _isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : _searchResults.isEmpty && _searchController.text.isNotEmpty
//                           ? Expanded(child: Center(child: Text('لا توجد نتائج', style: TextStyle(fontSize: 18))))
//                           : Expanded(
//                             child: ListView.builder(
//                               itemCount: _searchResults.length,
//                               itemBuilder: (context, index) {
//                                 return _buildSearchResultItem(_searchResults[index]);
//                               },
//                             ),
//                           ),
//                     ]
//                     : [
//                       SizedBox(
//                         height: 70,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 12, right: 12),
//                           child: Row(
//                             children: [
//                               CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
//                               horizontalSpace(12),
//                               Text('أهلا آحمد', style: TextStyles.font16BlacMedium.copyWith(fontSize: 20)),
//                               Spacer(),
//                               Icon(Icons.notifications),
//                             ],
//                           ),
//                         ),
//                       ),
//                       verticalSpace(12),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 12, right: 12),
//                         child: GestureDetector(
//                           onTap: _startSearch,
//                           child: AbsorbPointer(
//                             child: AppTextFormField(
//                               hintText: 'بحث',
//                               validator: (value) {
//                                 return null;
//                               },
//                               onChanged: (value) {},
//                               fillColor: Colors.white,
//                               prefixIcon: Icon(Icons.search),
//                             ),
//                           ),
//                         ),
//                       ),
//                       verticalSpace(12),
//                       Center(
//                         child: SizedBox(
//                           height: 40,
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: ListView(
//                               scrollDirection: Axis.horizontal,
//                               children:
//                                   context
//                                       .read<HomeCubit>()
//                                       .tags
//                                       .asMap()
//                                       .entries
//                                       .map((MapEntry map) => _buildTags(map.key))
//                                       .toList(),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(child: HomeBlocBuilder()),
//                     ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class Homescreen extends StatefulWidget {
//   const Homescreen({super.key});

//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }

// class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
//   int selectedTag = 0;
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";
//   List<DocumentSnapshot> allCars = [];
//   bool isLoading = false;
//   bool isSearchActive = false;

//   // Animation controller
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
  
//   context.read<HomeCubit>().getHomeData();


//     loadAllCars();

//     _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

//     // Setup slide animation
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0.3, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
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

  //   return allCars.where((doc) {
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     return (data['name']?.toString().toLowerCase() ?? '').contains(query) ||
  //         (data['typeCar']?.toString().toLowerCase() ?? '').contains(query) ||
  //         (data['model']?.toString().toLowerCase() ?? '').contains(query) ||
  //         (data['plateNumber']?.toString().toLowerCase() ?? '').contains(query) ||
  //         (data['city']?.toString().toLowerCase() ?? '').contains(query) ||
  //         (data['neighborhood']?.toString().toLowerCase() ?? '').contains(query);
  //   }).toList();
  // }

//   Widget _buildTags(int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTag = index;
//           isSearchActive = false;
//           searchQuery = "";
//           searchController.clear();
//           _animationController.reverse();

//           context.read<HomeCubit>().getHomeData(tagIndex: index);
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
//         ),
//         child: Text(
//           context.read<HomeCubit>().tags[index],
//           style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
//         ),
//       ),
//     );
//   }

//   // Widget _buildTags(int index) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       setState(() {
//   //         selectedTag = index;
//   //         isSearchActive = false;
//   //         searchQuery = "";
//   //         searchController.clear();
//   //         // Reverse animation when closing search
//   //         _animationController.reverse();
//   //       });
//   //     },
//   //     child: Container(
//   //       margin: const EdgeInsets.symmetric(horizontal: 5),
//   //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//   //       decoration: BoxDecoration(
//   //         // color: Theme.of(context).colorScheme.primaryContainer,
//   //         color: Colors.white,
//   //         borderRadius: BorderRadius.circular(15),
//   //         border: selectedTag == index ? Border.all(color: ColorsManager.kPrimaryColor, width: 2) : null,
//   //       ),
//   //       child: Text(
//   //         context.read<HomeCubit>().tags[index],
//   //         style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildSearchResults() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     List<DocumentSnapshot> filteredCars = getFilteredCars();

//     if (filteredCars.isEmpty) {
//       return const Center(child: Text("لا توجد نتائج"));
//     }

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: ListView.builder(
//           itemCount: filteredCars.length,
//           itemBuilder: (context, index) {
//             var car = filteredCars[index].data() as Map<String, dynamic>;
//             return ListTile(
//               leading:
//                   car['image'] != null
//                       ? Hero(
//                         tag: 'car_image_${filteredCars[index].id}',
//                         child: Image.network(car['image'], width: 50, height: 50, fit: BoxFit.cover),
//                       )
//                       : const Icon(Icons.directions_car, size: 50),
//               title: Text(car['name'] ?? "اسم غير متوفر"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("${car['typeCar'] ?? "نوع غير معروف"} - ${car['model'] ?? ""}"),
//                   Text("${car['city'] ?? ""} - ${car['plateNumber'] ?? ""}"),
//                 ],
//               ),
//               onTap: () {},
//             );
//           },
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     if (isSearchActive) {
//       return AppBar(
//         // backgroundColor: Colors.red,
//         elevation: 2,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             setState(() {
//               isSearchActive = false;
//               searchController.clear();
//               searchQuery = "";
//               // Reverse animation when closing search
//               _animationController.reverse();
//             });
//           },
//         ),
//         title: FadeTransition(
//           opacity: _fadeAnimation,
//           child: TextField(
//             controller: searchController,
//             autofocus: true,
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value;
//               });
//             },
//             decoration: InputDecoration(
//               hintText: "ابحث عن سيارة...",
//               border: InputBorder.none,
//               suffixIcon: AnimatedOpacity(
//                 opacity: searchQuery.isNotEmpty ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 200),
//                 child: IconButton(
//                   icon: const Icon(Icons.clear),
//                   onPressed:
//                       searchQuery.isEmpty
//                           ? null
//                           : () {
//                             setState(() {
//                               searchController.clear();
//                               searchQuery = "";
//                             });
//                           },
//                 ),
//               ),
//             ),
//             style: const TextStyle(color: Colors.black),
//           ),
//         ),
//       );
//     } else {
//       return AppBar(
//         // backgroundColor: ColorsManager.appBarColor,
//         backgroundColor: Colors.white,
//         elevation: 2,
//         title: Row(
//           children: [
//             const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
//             const SizedBox(width: 12),
//             Text('أهلا آحمد', style: TextStyle(color: Colors.black, fontSize: 20)),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.search, color: Colors.black),
//               onPressed: () {
//                 setState(() {
//                   isSearchActive = true;
//                   // Start animation when opening search
//                   _animationController.forward();
//                 });
//               },
//             ),
//             const Icon(Icons.notifications, color: Colors.black),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PostsCubit(),
//       child: Scaffold(
//         backgroundColor: ColorsManager.backgroundColor,
//         appBar: _buildAppBar(),

//         // backgroundColor: ColorsManager.backgroundColor,
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
//         body: Column(
//           children: [
//             const SizedBox(height: 12),
//             Expanded(
//               child:
//                   isSearchActive
//                       ? _buildSearchResults()
//                       : Column(
//                         children: [
//                           Center(
//                             child: SizedBox(
//                               height: 40,
//                               child: Directionality(
//                                 textDirection: TextDirection.rtl,
//                                 child: ListView(
//                                   scrollDirection: Axis.horizontal,
//                                   children:
//                                       context
//                                           .read<HomeCubit>()
//                                           .tags
//                                           .asMap()
//                                           .entries
//                                           .map((MapEntry map) => _buildTags(map.key))
//                                           .toList(),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           const Flexible(child: HomeBlocBuilderWrapper()),
//                         ],
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
// }

// class HomeBlocBuilderWrapper extends StatelessWidget {
//   const HomeBlocBuilderWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return HomeBlocBuilder(); // تأكد أنها مبنية صح داخل مشروعك
//   }
// }


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
