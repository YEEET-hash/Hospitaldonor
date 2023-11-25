import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:DonorConnect/donation_details.dart';
import 'package:DonorConnect/login.dart';

//hi da change

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyLogin(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.option,
    required this.switchValue,
  }) : super(key: key);

  final String title;
  final String option;
  final bool switchValue;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredData = [];
  String searchedRollNumber = '';
  Map<dynamic, dynamic> data = {};
  List<String> fdata = [];
  String kota = '';

  String? selectedOption;
  String selectedOptionValue = '';

  final ScrollController _scrollController = ScrollController();

  Future<void> _incrementCounter() async {
    fdata.clear();

    if (widget.option == 'A+') {
      selectedOptionValue = 'A+';
    } else if (widget.option == 'A-') {
      selectedOptionValue = 'A-';
    } else if (widget.option == 'A1-') {
      selectedOptionValue = 'A1-';
    } else if (widget.option == 'A1+') {
      selectedOptionValue = 'A1+';
    } else if (widget.option == 'A1B+') {
      selectedOptionValue = 'A1B+';
    } else if (widget.option == 'AB+') {
      selectedOptionValue = 'AB+';
    } else if (widget.option == 'B+') {
      selectedOptionValue = 'B+';
    } else if (widget.option == 'B-') {
      selectedOptionValue = 'B-';
    } else if (widget.option == 'O+') {
      selectedOptionValue = 'O+';
    } else if (widget.option == 'O-') {
      selectedOptionValue = 'O-';
    } else if (widget.option == 'AB-') {
      selectedOptionValue = 'AB-';
    } else if (widget.option == 'A1B-') {
      selectedOptionValue = 'AB1-';
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI/$selectedOptionValue",
    );
    DataSnapshot snapshot = (await ref.once()).snapshot;
    setState(() {
      data = snapshot.value as Map<dynamic, dynamic>;
    });
    data.forEach((key, value) {
      String name = value['NAME'];
      String addr = value['CONTACT_NO'].toString();
      String roll = value['ROLL_NO'].toString();
      String bon = value['DONATED'].toString();

      setState(() {
        print(widget.switchValue);
        print(bon);
        print(name);
        if (widget.switchValue == false) {
          if (bon == "Not Donated") {
            fdata.add("$roll Name: $name\nPh.no: $addr ");
          }
        } else {
          if (bon != "Not Donated") {
            fdata.add("$roll Name: $name\nPh.no: $addr ");
          }
        }
      });
    });
  }

  Future<void> _showFullData(String bata) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI/$selectedOptionValue/$bata",
    );
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    if (!snapshot.exists) {
      return;
    }

    dynamic data = snapshot.value;
    if (data is Map) {
      String name = data['NAME'];
      String phno = data['CONTACT_NO'].toString();
      String roll = data['ROLL_NO'].toString();
      String addr1 = data['ADDRESS1'].toString();
      String addr2 = data['ADDRESS2'].toString();
      String addr3 = data['ADDRESS3'].toString();
      String don = data['DONATED'].toString();

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Info'),
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Roll no: $roll\nName: $name\nPh.no: $phno\nAddress: $addr1 $addr2,$addr3\nDonated: $don",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.access_time), // Clock icon
                onPressed: () {
                  fetchDataFromFirebase(bata);
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: "View Details",
                      child: Text("View Details"),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == "View Details") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationDetailsPage(
                          bata: bata,
                          selectedOptionValue: selectedOptionValue,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchDataFromFirebase(String bata) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI/$selectedOptionValue/$bata",
    );
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    dynamic data = snapshot.value;
    String dat = data['DONATION_DATE'].toString();
    String hos = data['NAME_OF_HOSPITAL'].toString();
    String fac = data['FacultyName'].toString();
    List<String> items = [];

    String daa = 'd';
    int i = 0;
    while (daa != "null") {
      if (data is Map) {
        daa = data[i.toString()].toString();
        if (daa != "null") {
          items.add(daa);
        }
      }
      i++;
    }
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Donation Details'
            "\nDonated Date: $dat\nHospital Name: $hos\nFaculty Name: $fac",
            style: const TextStyle(fontSize: 16.0),
          ),
          content: Container(
            width: screenSize.width * 0.8, // 80% of screen width
            height: screenSize.height * 0.5, // 50% of screen height
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _incrementCounter(); // Call _incrementCounter here
  }

  void _search(String searchText) {
    filteredData = fdata.where((item) => item.contains(searchText)).toList();
    setState(() {
      searchedRollNumber = searchText;
      if (searchedRollNumber.isNotEmpty) {
        int index =
            fdata.indexWhere((item) => item.startsWith(searchedRollNumber));
        if (index != -1) {
          scrollToIndex(index);
        }
      }
    });
  }

  void scrollToIndex(int index) {
    _scrollController.animateTo(
      index * 50.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSearchResults() {
    if (filteredData.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filteredData.map((result) {
        final rollNumber = result.substring(0, 11);
        return InkWell(
          onTap: () {
            _showFullData(rollNumber);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              result,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Search'),
                    content: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          _search(value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Roll Number',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            searchController.clear();
                            filteredData.clear();
                            searchedRollNumber = '';
                          });
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 5,
                  ),
                  itemCount: fdata.length,
                  itemBuilder: (context, index) {
                    final item = fdata[index].substring(12);
                    final rollNumber = fdata[index].substring(0, 11);
                    final isHighlighted = filteredData.contains(fdata[index]);
                    return Card(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showFullData(rollNumber);
                            print(rollNumber);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: isHighlighted ? Colors.red : null,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.phone),
                                onPressed: () async {
                                  final int last10Index =
                                      fdata[index].length - 11;
                                  final String last10Chars = fdata[index]
                                      .substring(
                                          last10Index < 0 ? 0 : last10Index);

                                  final Uri url = Uri(
                                    scheme: 'tel',
                                    path: last10Chars,
                                  );

                                  if (await canLaunch(url.toString())) {
                                    await launch(url.toString());
                                  } else {
                                    print('Cannot launch this URL');
                                  }
                                },
                                iconSize: 30.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  controller: _scrollController,
                ),
              ),

              // Display search results
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }
}
