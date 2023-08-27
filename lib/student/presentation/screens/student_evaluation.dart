// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:online_quran_frontend/student/presentation/components/try_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';





// import '../../data_providers/local_db/db.dart';
// import '../../models/login_details.dart';

// import 'package:google_fonts/google_fonts.dart';

// import '../components/student_search_delegate.dart';

// class WhiteScreen extends StatelessWidget {
//   final List<Student> students_fetched;

//   WhiteScreen(this.students_fetched);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: StudentList(students_fetched));
//   }
// }

// class StudentList extends StatefulWidget {
//   final List<Student> students_fetched;

//   StudentList(this.students_fetched);
//   @override
//   _StudentListState createState() => _StudentListState();
// }

// class _StudentListState extends State<StudentList> {

//   final List<Student> students = [
//     Student(name: 'John Doe', avatarUrl: 'https://example.com/avatar1.png'),
//     Student(name: 'Jane Doe', avatarUrl: 'https://example.com/avatar2.png'),
//     Student(name: 'Bob Smith', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'Abdulmelik Ambaw', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(name: 'Sheik Shemsu', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(name: 'Khalid Abdu', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(name: 'Amir Ahmedin', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(name: 'Temame', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'Abubeker Ibn Osman',
//         avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'Umer Ibn Khetab', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'osman bin Affan', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'Aliy bin Abi talib',
//         avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'Seid Ibn Muaz', avatarUrl: 'https://example.com/avatar3.png'),
//     Student(
//         name: 'Ihteze Lehu Arshu',
//         avatarUrl: 'https://example.com/avatar3.png'),
//     Student(name: 'Ibadellah', avatarUrl: 'https://example.com/avatar3.png'),
//   ];

//   @override
//   Widget build(BuildContext context) {
    
//     final ScrollController _scrollController = ScrollController();
//     Size size = MediaQuery.of(context).size;

//     var brightness = Brightness.dark;
//     bool isDarkMode = brightness == Brightness.dark;
//     void navigateToStudent(int index) {
//       double itemExtent = 150;
//       _scrollController.animateTo(
//         index * itemExtent,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }

//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(50.0),
//           child: AppBar(
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 GoRouter.of(context).push("/ustazprofile");
//               },
//             ),
//             backgroundColor: Color.fromARGB(255, 31, 34, 36),
//             title: Text(
//               'Student List',
//               style: GoogleFonts.poppins(
//                 color: isDarkMode ? Colors.white : const Color(0xff1D1617),
//                 fontSize: size.height * 0.03,
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: EdgeInsets.only(right: 24),
//                 child: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     showSearch(
//                       context: context,
//                       delegate:
//                           StudentSearchDelegate(students, navigateToStudent),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//         body: Container(
//           padding: EdgeInsets.only(
//             top: size.height * 0.05,
//           ),
//           height: size.height,
//           width: size.width * 1.1,
//           decoration: BoxDecoration(
//             color: isDarkMode ? Color.fromARGB(255, 31, 34, 36) : Colors.white,
//           ),
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: students.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Padding(
//                 padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? Color.fromARGB(255, 55, 60, 63)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     children: [
//                       ListTile(
//                         contentPadding: EdgeInsets.fromLTRB(3, 3, 3, 3),
//                         leading: CircleAvatar(
//                           backgroundImage: const NetworkImage(
//                               "https://source.unsplash.com/random"),
//                           radius: 25.0, // the radius of the CircleAvatar
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           students[index].name,
//                           style: GoogleFonts.poppins(
//                             color: isDarkMode
//                                 ? Colors.white
//                                 : const Color(0xff1D1617),
//                             fontSize: size.height * 0.03,
//                           ),
//                         ),
//                         trailing: Padding(
//                           padding: EdgeInsets.only(right: 8),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 students[index].isPresent =
//                                     !students[index].isPresent;
//                               });
//                             },
//                             child: Icon(
//                               students[index].isPresent
//                                   ? Icons.check_circle
//                                   : Icons.radio_button_unchecked,
//                               color: students[index].isPresent
//                                   ? Colors.green
//                                   : Colors.grey,
//                               size: size.height * 0.05,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(40, 0, 16, 16),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     'Score',
//                                     style: GoogleFonts.poppins(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : const Color(0xff1D1617),
//                                       fontSize: size.height * 0.02,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 0),
//                                 SizedBox(
//                                   width: 60,
//                                   height: 32,
//                                   child: TextFormField(
//                                     initialValue:
//                                         students[index].score.toString(),
//                                     style: GoogleFonts.poppins(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : const Color(0xff1D1617),
//                                       fontSize: size.height * 0.02,
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         students[index].score =
//                                             int.tryParse(value) ?? 0;
//                                       });
//                                     },
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(
//                                           vertical: 10, horizontal: 16),
//                                       filled: true,
//                                       fillColor: isDarkMode
//                                           ? Color.fromARGB(255, 40, 42, 44)
//                                           : Colors.grey[200],
//                                       border: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 10),
//                                     child: Text(
//                                       'Surah',
//                                       style: GoogleFonts.poppins(
//                                         color: isDarkMode
//                                             ? Colors.white
//                                             : const Color(0xff1D1617),
//                                         fontSize: size.height * 0.02,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 0),
//                                   SizedBox(
//                                     width: 109,
//                                     height: 32,
//                                     child: DropdownButtonFormField<String>(
//                                       style: GoogleFonts.poppins(
//                                         color: isDarkMode
//                                             ? Colors.white
//                                             : const Color(0xff1D1617),
//                                         fontSize: size.height * 0.02,
//                                       ),
//                                       value: students[index].startSurah,
//                                       items: [
//                                         'Al-Fatiha',
//                                         'Al-Baqara',
//                                         'Al-Imran',
//                                         'An-Nisa',
//                                         'Al-Maida'
//                                       ].map((surah) {
//                                         return DropdownMenuItem<String>(
//                                           value: surah,
//                                           child: Text(surah),
//                                         );
//                                       }).toList(),
//                                       onChanged: (value) {
//                                         setState(() {
//                                           students[index].startSurah = value;
//                                         });
//                                       },
//                                       decoration: InputDecoration(
//                                         contentPadding: EdgeInsets.symmetric(
//                                             vertical: 10, horizontal: 16),
//                                         filled: true,
//                                         fillColor: isDarkMode
//                                             ? Color.fromARGB(255, 40, 42, 44)
//                                             : Colors.grey[200],
//                                         border: OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     'Ayah',
//                                     style: GoogleFonts.poppins(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : const Color(0xff1D1617),
//                                       fontSize: size.height * 0.02,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 0),
//                                 SizedBox(
//                                   width: 60,
//                                   height: 32,
//                                   child: TextFormField(
//                                     initialValue:
//                                         students[index].score.toString(),
//                                     style: GoogleFonts.poppins(
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : const Color(0xff1D1617),
//                                       fontSize: size.height * 0.02,
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         students[index].score =
//                                             int.tryParse(value) ?? 0;
//                                       });
//                                     },
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(
//                                           vertical: 10, horizontal: 16),
//                                       filled: true,
//                                       fillColor: isDarkMode
//                                           ? Color.fromARGB(255, 40, 42, 44)
//                                           : Colors.grey[200],
//                                       border: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(bottom: 8),
//                         child: ElevatedButton(
//                           child: Text("Save"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: true
//                                 ? const Color(0xff252525)
//                                 : const Color(
//                                     0xff92A3FD), // set the button background color
//                             onPrimary: Colors.white, // set the text color
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   15), // set the button border radius
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 16, horizontal: 32),
//                           ),
//                           onPressed: () {},
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ));
//   }
// }
