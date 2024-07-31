// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class AnalyticsPage extends StatefulWidget {
//   @override
//   _AnalyticsPageState createState() => _AnalyticsPageState();
// }
//
// class _AnalyticsPageState extends State<AnalyticsPage> {
//   DatabaseReference _bloodGroupRef = FirebaseDatabase.instance
//       .reference()
//       .child('1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI');
//
//   Map<String, int> bloodGroupCounts = {};
//
//   bool _isLoading = true;
//   bool _showText = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchBloodGroupData();
//   }
//
//   Future<void> _fetchBloodGroupData() async {
//     DataSnapshot snapshot = (await _bloodGroupRef.once()).snapshot;
//
//     if (snapshot.value != null) {
//       Map<dynamic, dynamic>? bloodGroups =
//           snapshot.value as Map<dynamic, dynamic>?;
//
//       if (bloodGroups != null) {
//         bloodGroups.forEach((key, value) {
//           bloodGroupCounts[key] = (value as Map).length;
//         });
//       }
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Color getRandomColor() {
//     Random random = Random();
//     return Color.fromARGB(
//       255,
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blood Group Analytics'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
//               ),
//             )
//           : bloodGroupCounts.isNotEmpty
//               ? Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'Blood Group Analytics',
//                         style: TextStyle(
//                           fontSize: 24.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 20.0),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _showText = !_showText;
//                             });
//                           },
//                           child: Stack(
//                             children: [
//                               PieChart(
//                                 PieChartData(
//                                   sections: bloodGroupCounts.entries
//                                       .map(
//                                         (entry) => PieChartSectionData(
//                                           value: entry.value.toDouble(),
//                                           title: entry.key,
//                                           color: getRandomColor(),
//                                           radius:
//                                               150, // Increase the radius for a bigger chart
//                                           titleStyle: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors
//                                                 .black, // Set text color to black
//                                           ),
//                                         ),
//                                       )
//                                       .toList(),
//                                   sectionsSpace: 0,
//                                   centerSpaceRadius: 0,
//                                   borderData: FlBorderData(show: false),
//                                   // You can add more configurations for the pie chart here
//                                 ),
//                               ),
//                               if (_showText)
//                                 Positioned(
//                                   left: 0,
//                                   right: 0,
//                                   bottom: 0,
//                                   child: Container(
//                                     color: Colors.white,
//                                     padding: EdgeInsets.all(16),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.stretch,
//                                       children: [
//                                         DataTable(
//                                           columns: [
//                                             DataColumn(
//                                                 label: Text('Blood Group')),
//                                             DataColumn(label: Text('Count')),
//                                           ],
//                                           rows: bloodGroupCounts.entries
//                                               .map(
//                                                 (entry) => DataRow(
//                                                   cells: [
//                                                     DataCell(Text(entry.key)),
//                                                     DataCell(Text(entry.value
//                                                         .toString())),
//                                                   ],
//                                                 ),
//                                               )
//                                               .toList(),
//                                         ),
//                                         SizedBox(height: 10),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               _showText = false;
//                                             });
//                                           },
//                                           child: Text('Back'),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : Center(
//                   child: Text(
//                     'No data available',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ),
//     );
//   }
// }
