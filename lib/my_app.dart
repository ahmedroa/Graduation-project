import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graduation/core/widgets/error.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ErrorWidget.builder = (FlutterErrorDetails error) {
      return ErrorPage();
    };

    FlutterNativeSplash.remove();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale("ar", "AE")],
        locale: const Locale("ar", "AE"),
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // initialRoute: context.isNotLoggedIn ? Routes.splashView : Routes.bottomNavBar,
        initialRoute: Routes.bottomNavBar,
        onGenerateRoute: appRouter.generateRoute,
        // home: SearchPage(),
      ),
    );
  }
}

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";
//   List<DocumentSnapshot> allCars = [];
//   bool isLoading = true;

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("البحث عن السيارات")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AppTextFormField(
//               hintText: 'بحث في جميع الحقول...',
//               validator: (v) {
//                 return null;
//               },
//               controller: searchController,
//               onChanged: (value) {
//                 setState(() {
//                   searchQuery = value;
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child:
//                 isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     : Builder(
//                       builder: (context) {
//                         List<DocumentSnapshot> filteredCars = getFilteredCars();

//                         if (filteredCars.isEmpty) {
//                           return Center(child: Text("لا توجد نتائج"));
//                         }

//                         return ListView.builder(
//                           itemCount: filteredCars.length,
//                           itemBuilder: (context, index) {
//                             var car = filteredCars[index].data() as Map<String, dynamic>;
//                             return ListTile(
//                               leading:
//                                   car['image'] != null
//                                       ? Image.network(car['image'], width: 50, height: 50, fit: BoxFit.cover)
//                                       : Icon(Icons.directions_car, size: 50),
//                               title: Text(car['name'] ?? "اسم غير متوفر"),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("${car['typeCar'] ?? "نوع غير معروف"} - ${car['model'] ?? ""}"),
//                                   Text("${car['city'] ?? ""} - ${car['plateNumber'] ?? ""}"),
//                                 ],
//                               ),
//                               onTap: () {},
//                             );
//                           },
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("البحث عن السيارات")),
//       body: Column(
//         children: [
//           AppTextFormField(
//             hintText: 'Search',
//             validator: (v) {
//               return null;
//             },
//           ),

//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream:
//                   (searchQuery.isEmpty)
//                       ? FirebaseFirestore.instance.collection('posts').snapshots()
//                       : FirebaseFirestore.instance
//                           .collection('posts')
//                           .where('name', isGreaterThanOrEqualTo: searchQuery)
//                           .where('name', isLessThan: '$searchQuery\uf8ff')
//                           .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text("لا توجد نتائج"));
//                 }

//                 var cars = snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: cars.length,
//                   itemBuilder: (context, index) {
//                     var car = cars[index].data() as Map<String, dynamic>;

//                     return ListTile(
//                       leading:
//                           car['image'] != null
//                               ? Image.network(car['image'], width: 50, height: 50, fit: BoxFit.cover)
//                               : Icon(Icons.directions_car, size: 50),
//                       title: Text(car['name'] ?? "اسم غير متوفر"),
//                       subtitle: Text(car['typeCar'] ?? "نوع غير معروف"),
//                       onTap: () {
//                         // يمكنك فتح صفحة التفاصيل هنا
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
