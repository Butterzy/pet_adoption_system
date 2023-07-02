/*  import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/bar_chart_model.dart';

class Report extends StatelessWidget {
  Report({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text('Overall Report',
              //customize textStyle in theme() method
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white)),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        
                        
                      ),
          Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
                      200.0,
            ),
            padding: const EdgeInsets.all(8.0),
            color: Colors.indigo[100],
            alignment: Alignment.center,
            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                          boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                        ),
            child: FutureBuilder<int>(
              future: getTotalPets(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Number of strays: ${snapshot.data}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.indigo));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
                      200.0,
            ),
            padding: const EdgeInsets.all(8.0),
            color: Colors.indigo[100],
            alignment: Alignment.center,
            child: FutureBuilder<int>(
              future: getTotalApplications(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      'Number of adoption applications: ${snapshot.data}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.indigo));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),

/*           Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
                      200.0,
            ),
            padding: const EdgeInsets.all(8.0),
            color: Colors.indigo[100],
            alignment: Alignment.center,
            child: FutureBuilder<int>(
              future: getTotalApplications(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      'Number of adoption applications: ${snapshot.data}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.indigo));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ), */ 
          Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
                      200.0,
            ),
            padding: const EdgeInsets.all(8.0),
            color: Colors.indigo[100],
            alignment: Alignment.center,
            child: FutureBuilder<int>(
              future: getTotalUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Number of users: ${snapshot.data}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.indigo));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ), 
    );
  }

    Future<int> getTotalUser() async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await userCollection.get();
    int count = snapshot.size;
    return count;
  }

  Future<int> getTotalApplications() async {
    final CollectionReference registerCollection =
        FirebaseFirestore.instance.collection('registers');
    QuerySnapshot snapshot = await registerCollection.get();
    int count = snapshot.size;
    return count;
  }

  Future<int> getTotalPets() async {
    final CollectionReference petsCollection =
        FirebaseFirestore.instance.collection('pets');
    QuerySnapshot snapshot = await petsCollection.get();
    int count = snapshot.size;
    return count;
  }

  
  
}  */