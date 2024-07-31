import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DonationDetailsPage extends StatefulWidget {
  final String bata;
  final String selectedOptionValue;

  const DonationDetailsPage({
    Key? key,
    required this.bata,
    required this.selectedOptionValue,
  }) : super(key: key);

  @override
  _DonationDetailsPageState createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  bool isDonated = false;
  String hospitalName = "";
  String facultyName = "";
  String sre = "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI";
  String srh = "1q0JBlAZa9bvIxEWdSIVRF6-LE3VnZQX9VVWixiTebrU";
  String conn = "1q0JBlAZa9bvIxEWdSIVRF6-LE3VnZQX9VVWixiTebrU";
  DatabaseReference get databaseReference => FirebaseDatabase.instance
      .ref("$conn/${widget.selectedOptionValue}/${widget.bata}");

  Future<void> updateDonationStatus() async {
    final ref = databaseReference;
    var donationStatus = isDonated ? "Donated" : "Not Donated";
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    dynamic data = snapshot.value;

    if (data is Map) {
      int count = data['DONATION_COUNT'];

      if (isDonated) {
        final newDonationKey = count.toString();
        final dataToAdd = {
          newDonationKey: {
            'DONATED': donationStatus,
            'DONATION_DATE': DateTime.now().toIso8601String(),
            'NAME_OF_HOSPITAL': hospitalName,
            'FacultyName': facultyName,
          }
        };
        count = count + 1;
        await ref.update(dataToAdd.cast<String, Object?>());
        await ref.update({'DONATED': donationStatus});
        await ref.update({"DONATION_COUNT": count++}.cast<String, Object?>());
      } else {
        final dataToUpdate = {
          'DONATED': donationStatus,
        };

        await ref.update(dataToUpdate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Roll no: ${widget.bata}\n\n",
              style: TextStyle(
                fontSize: 25,
                color: Colors.purple,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent,
                    offset: Offset(2, 1),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  facultyName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Faculty Name',
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  hospitalName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Hospital Name',
              ),
            ),
            CheckboxListTile(
              title: Text("Donted"),
              value: isDonated,
              onChanged: (newValue) {
                setState(() {
                  isDonated = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await updateDonationStatus();
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
