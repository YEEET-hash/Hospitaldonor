import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  dynamic _userData; // State variable to hold fetched data
  List<Widget> _builderList = [];
  bool _isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("RequestedPeople");
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    setState(() {
      _userData = snapshot.value;
      _isLoading = false; // Data fetched, loading complete
      buildList(); // Call buildList after setting _userData
    });
  }

  Future<void> update(ref1, value, key) async {
    DatabaseEvent event = await ref1.once();
    DataSnapshot snapshot = event.snapshot;
    dynamic odata = snapshot.value;
    print(odata);
    print("dfsdfsdf");
    //Requested people
    DatabaseReference ref2 = FirebaseDatabase.instance.ref("RequestedPeople");
    //requested fetch
    int count = odata['DONATION_COUNT'];
    String hospitalName = value['NAME_OF_HOSPITAL'];
    String facultyName = value['FacultyName'];
    String email = value['EMAIL'];
    String date1 = value['DONATION_DATE'];
    final newDonationKey = count.toString();
    final dataToAdd = {
      newDonationKey: {
        'DONATED': 'Donated',
        'Email': email,
        'DONATION_DATE': date1,
        'NAME_OF_HOSPITAL': hospitalName,
        'FacultyName': facultyName,
      }
    };
    count = count + 1;
    await ref1.update(dataToAdd.cast<String, Object?>());
    await ref1.update({'DONATED': 'Donated'});
    await ref1.update({"DONATION_COUNT": count++}.cast<String, Object?>());
    ref2.child(key).remove().then((_) {
      print("Data deleted successfully.");
    });
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> update1(key) async {
    DatabaseReference ref2 = FirebaseDatabase.instance.ref("RequestedPeople");
    ref2.child(key).remove().then((_) {
      print("Data deleted successfully.");
    });
  }

  void buildList() {
    _userData?.forEach((key, value) {
      if (key != null && value != null && value is Map) {
        String rollNumber = key.toString();
        String name = value['NAME']?.toString() ?? 'Unknown';
        String blood = value['BLOODGROUP'];
        // Create a custom widget for each list item
        Widget listItem = Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Roll No: $rollNumber'),
                    Text('Name: $name'),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      DatabaseReference ref1 = FirebaseDatabase.instance.ref(
                          "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI/$blood/$rollNumber");
                      update(ref1, value, key);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      update1(key);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );

        setState(() {
          _builderList.insert(0, listItem);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Request'),
          backgroundColor: Colors.blue,
          shape: ContinuousRectangleBorder()),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : ListView(
              padding: EdgeInsets.all(16),
              children: _builderList,
            ),
    );
  }
}
