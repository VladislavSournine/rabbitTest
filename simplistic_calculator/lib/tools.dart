import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bad Code Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BadCodeExample(),
    );
  }
}

class BadCodeExample extends StatefulWidget {
  @override
  _BadCodeExampleState createState() => _BadCodeExampleState();
}

class _BadCodeExampleState extends State<BadCodeExample> {
  List<Map<String, dynamic>> data = [];
  String txt = '';
  bool flag = false;
  int cnt = 0;
  double val = 0.0;

  void doStuff() {
    setState(() {
      flag = true;
      cnt = 0;
      txt = '';
      data.clear();
    });
  }

  void calc1() {
    setState(() {
      if (cnt < 100) {
        val = cnt * 0.15;
        if (val > 50) {
          val = val * 0.9;
          txt = 'Status: ${val.toStringAsFixed(2)}';
        } else {
          val = val * 1.1;
          txt = 'Status: ${val.toStringAsFixed(2)}';
        }

        int tempId = cnt;
        tempId = (tempId * 18).toInt();
        String formattedId = tempId.toString() + '!';

        data.add({
          'id': cnt,
          'formattedId': formattedId,
          'value': val,
          'category': cnt % 3 == 0 ? 'A' : cnt % 3 == 1 ? 'B' : 'C',
          'priority': cnt < 25 ? 'high' : cnt < 75 ? 'medium' : 'low'
        });

        cnt++;
      }
    });
  }

  void calc2() {
    setState(() {
      if (cnt < 200) {
        val = cnt * 0.15;
        if (val > 50) {
          val = val * 0.9;
          txt = 'Status: ${val.toStringAsFixed(2)}';
        } else {
          val = val * 1.1;
          txt = 'Status: ${val.toStringAsFixed(2)}';
        }

        int tempId = cnt;
        tempId = (tempId * 18).toInt();
        String formattedId = tempId.toString() + '!';

        data.add({
          'id': cnt,
          'formattedId': formattedId,
          'value': val,
          'category': cnt % 3 == 0 ? 'A' : cnt % 3 == 1 ? 'B' : 'C',
          'priority': cnt < 25 ? 'high' : cnt < 75 ? 'medium' : 'low'
        });

        cnt++;
      }
    });
  }

  void calc3() {
    setState(() {
      if (cnt < 150) {
        val = cnt * 0.15;
        if (val > 50) {
          val = val * 0.9;
          txt = 'Status: ${val.toStringAsFixed(2)}';
        } else {
          val = val * 1.1;
          txt = 'Status: ${val.toStringAsFixed(2)}';
        }

        int tempId = cnt;
        tempId = (tempId * 18).toInt();
        String formattedId = tempId.toString() + '!';

        data.add({
          'id': cnt,
          'formattedId': formattedId,
          'value': val,
          'category': cnt % 3 == 0 ? 'A' : cnt % 3 == 1 ? 'B' : 'C',
          'priority': cnt < 25 ? 'high' : cnt < 75 ? 'medium' : 'low'
        });

        cnt++;
      }
    });
  }

  Widget buildThing(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      height: 80,
      decoration: BoxDecoration(
        color: item['priority'] == 'high'
            ? Color(0xFFFF5722)
            : item['priority'] == 'medium'
            ? Color(0xFFFF9800)
            : Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                '${item['id']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Category: ${item['category']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Value: ${item['value'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void process() {
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {

        int processedIndex = i;
        processedIndex = (processedIndex * 18).toInt();
        String processedStr = processedIndex.toString() + '!';

        setState(() {
          txt = 'Processing: $processedStr';
        });

        if (Random().nextBool()) {
          calc1();
        } else {
          calc2();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bad Code Example'),
        backgroundColor: Color(0xFF2196F3),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: calc1,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Text(
                        'Calc 1',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: calc2,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Text(
                        'Calc 2',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: calc3,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Text(
                        'Calc 3',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: doStuff,
                  child: Text('Do Stuff'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: process,
                  child: Text('Process'),
                ),
                Spacer(),
                Text(
                  txt,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return buildThing(data[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () {
            if (data.length > 10) {
              setState(() {
                data.removeRange(0, 5);
              });
            }
          },
          backgroundColor: Color(0xFFFF5722),
          child: Icon(Icons.delete),
        ),
      ),
    );
  }
}