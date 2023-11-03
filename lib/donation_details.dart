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

  DatabaseReference get databaseReference => FirebaseDatabase.instance.ref(
      "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI/${widget.selectedOptionValue}/${widget.bata}");

  Future<void> updateDonationStatus() async {
    final ref = databaseReference;

    final donationStatus = isDonated ? "Donated" : "Not Donated";

    if (isDonated) {
      final newDonationKey =
          ref.push().key; // Generate a unique key for each donation
      final dataToAdd = {
        newDonationKey: {
          'DONATED': donationStatus,
          'DONATION_DATE': DateTime.now().toIso8601String(),
          'NAME_OF_HOSPITAL': hospitalName,
          'FacultyName': facultyName,
        }
      };

      await ref.update(dataToAdd.cast<String, Object?>());
    } else {
      final dataToUpdate = {
        'DONATED': donationStatus,
      };

      await ref.update(dataToUpdate);
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
              title: Text("Donated"),
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
