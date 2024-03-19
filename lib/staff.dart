import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DonationDetailsPage extends StatelessWidget {
  final String selectedOptionValue;
  final String rollNumber;
  String  sre = "1XyRygScOczkhXImWGD4ehnGwIze8bftFnABelt9mtAI";
  String  srh = "1q0JBlAZa9bvIxEWdSIVRF6-LE3VnZQX9VVWixiTebrU";
  String  conn= "1q0JBlAZa9bvIxEWdSIVRF6-LE3VnZQX9VVWixiTebrU";

  DonationDetailsPage({
    required this.selectedOptionValue,
    required this.rollNumber,
  });

  Future<void> _showDonationDetails(BuildContext context) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "$conn/$selectedOptionValue/$rollNumber",
    );

    DataSnapshot dataSnapshot = (await ref.once()) as DataSnapshot;

    if (dataSnapshot.value == null) {
      // Handle the case where there are no donations
      return;
    }

    Map<String, dynamic> data = dataSnapshot.value as Map<String, dynamic>;

    data.forEach((donationKey, donationData) {
      if (donationData is Map) {
        String donationStatus = donationData['DONATED'] ?? "N/A";
        String donationDate = donationData['DONATION_DATE'] ?? "N/A";
        String facultyName = donationData['FacultyName'] ?? "N/A";
        String hospitalName = donationData['NAME_OF_HOSPITAL'] ?? "N/A";

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Donation Details'),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Donation Key: $donationKey"),
                    Text("Donation Status: $donationStatus"),
                    Text("Donation Date: $donationDate"),
                    Text("Faculty Name: $facultyName"),
                    Text("Hospital Name: $hospitalName"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showDonationDetails(context);
              },
              child: Text('View Donation Details'),
            ),
          ],
        ),
      ),
    );
  }
}
