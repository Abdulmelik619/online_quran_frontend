import 'package:flutter/material.dart';

import '../../models/student.dart';

class StudentSearchDelegate extends SearchDelegate<Student> {
  final List<Student> students;
  final Function onSelect;

  StudentSearchDelegate(
    this.students,
    this.onSelect,
  );
  // final ScrollController _scrollController = ScrollController();
  var brightness = Brightness.dark;

  bool isDarkMode = true;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        color: Color.fromARGB(255, 20, 25, 29), // Change the color to blue
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: TextStyle(
          color: Colors.white,
          fontWeight:
              FontWeight.w200, // Change the color of the "Search" text to white
        ),
        labelStyle: TextStyle(
          color:
              Colors.white, // Change the color of the "Search" label to white
          fontWeight:
              FontWeight.w200, // Set the font weight to a lighter weight
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,

          fontWeight:
              FontWeight.w200, // Change the color of the "Search" text to white
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, students[0]);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bool isPresent = true;
    int score = 0;

    double attendance = 0;
    final results = students
        .where((student) =>
            student.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
        body: Container(
      color: isDarkMode ? Colors.white : Color.fromARGB(255, 31, 34, 36),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final student = results[index];

          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    leading: CircleAvatar(
                      backgroundImage: const NetworkImage(
                          "https://source.unsplash.com/random"),
                      radius: 25.0, // the radius of the CircleAvatar
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    title: Text(
                      student.fullName,
                      style: TextStyle(
                        color: const Color(0xff1D1617),
                        fontSize: 18.0,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        isPresent = !isPresent;
                        Navigator.pop(context, student);
                      },
                      child: Icon(
                        isPresent
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isPresent ? Colors.green : Colors.grey,
                        size: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(64, 0, 16, 16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Score',
                                style: TextStyle(
                                  color: const Color(0xff1D1617),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 0),
                            SizedBox(
                              width: 60,
                              height: 32,
                              child: TextFormField(
                                initialValue: score.toString(),
                                style: TextStyle(
                                  color: const Color(0xff1D1617),
                                  fontSize: 16.0,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                score = int.tryParse(value) ?? 0;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF2F2F2),
                                ),
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Attendance',
                                style: TextStyle(
                                  color: const Color(0xff1D1617),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 0),
                            SizedBox(
                              width: 60,
                              height: 32,
                              child: TextFormField(
                                initialValue: attendance.toString(),
                                style: TextStyle(
                                  color: const Color(0xff1D1617),
                                  fontSize: 16.0,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  attendance = double.tryParse(value) ?? 0.0;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF2F2F2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = students
        .where((student) =>
            student.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      body: Container(
        color: isDarkMode ? Color.fromARGB(255, 31, 34, 36) : Colors.white,
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final student = results[index];

            return Container(
              decoration: BoxDecoration(
                color:
                    isDarkMode ? Color.fromARGB(255, 31, 34, 36) : Colors.white,
              ),
              child: ListTile(
                title: Text(
                  student.fullName,
                  style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : Color.fromARGB(255, 31, 34, 36)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onSelect(students.indexOf(student));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
