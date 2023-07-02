import 'package:flutter/material.dart';

import 'package:pet_adoption_system/screens/report/adopted_pie_chart.dart';
import 'package:pet_adoption_system/screens/report/role_pie_chart.dart';
import 'package:pet_adoption_system/screens/report/status_pie_chart.dart';
import 'package:pet_adoption_system/screens/report/category_pie_chart.dart';

class Graph extends StatelessWidget {
  Graph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text('Report',
              //customize textStyle in theme() method
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white)),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
/*         actions: [
          IconButton(
              tooltip: 'Generate Report',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Report(),
                    ));
              },
              icon: const Icon(
                Icons.article_outlined,
                color: Colors.white,
              ))
        ], */
      ),
      body: SingleChildScrollView(
        
        child: Container(

              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
            
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  child: const AdoptedPieChart(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  child: const CategoryPieChart(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  child: const StatusPieChart(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  child: const UserPieChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
