import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'The category of available pets',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.indigo),
        ),
        const SizedBox(height: 40.0),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('pets').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            final dataMap = <String, int>{};
            for (final doc in documents) {
              final petCategory = doc.get('pet_category');
              dataMap.update(petCategory, (value) => value + 1,
                  ifAbsent: () => 1);
            }

            if (dataMap.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Center(
                  child: Text(
                    'No records',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                ),
              );
            }

            return PieChart(
              dataMap:
                  dataMap.map((key, value) => MapEntry(key, value.toDouble())),
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: math.min(MediaQuery.of(context).size.width, 300),
              colorList: const [
                Color(0xfffdcb6e),
                Color(0xff0984e3),
                Color(0xfffd79a8),
                Color(0xffe17055),
                Color(0xff6c5ce7),
              ],
              initialAngleInDegree: 0,
              emptyColor: Colors.grey,
              emptyColorGradient: const [
                Color(0xff6c5ce7),
                Colors.blue,
              ],
              baseChartColor: Colors.transparent,
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesOutside: true,
                decimalPlaces: 0,
              ),
            );
          },
        ),
      ],
    );
  }
}
