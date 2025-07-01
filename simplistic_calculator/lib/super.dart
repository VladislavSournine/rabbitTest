// Unused file that does nothing but exists
// This file demonstrates ALL bad practices in one place

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// Global variables instead of proper state management
int globalCounter = 0;
String globalMessage = '';
bool globalFlag = false;
List<String> globalData = [];

// Unused function with incorrect comment
/// This function calculates the square of a number
int calculateFactorial(int n) {  // Comment is wrong - it's factorial not square!
  if (n <= 1) return 1;
  return n * calculateFactorial(n - 1);  // Recursive - could be iterative
}

// Unused class
class UnusedUtility {
  static void doNothing() {
    print('This method is never called');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comprehensive Bad Code Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BadCodeWidget(),
    );
  }
}

// Excessive inheritance - Level 1
abstract class Entity {
  String id = '';
  DateTime created = DateTime.now();
}

// Level 2
abstract class NamedEntity extends Entity {
  String name = '';
  String desc = '';
}

// Level 3
abstract class TimestampedEntity extends NamedEntity {
  DateTime updated = DateTime.now();
  String status = 'active';
}

// Level 4
abstract class CacheableEntity extends TimestampedEntity {
  bool cached = false;
  String cacheKey = '';
}

// Level 5
abstract class SerializableEntity extends CacheableEntity {
  Map<String, dynamic> meta = {};
}

// Level 6
abstract class ValidatableEntity extends SerializableEntity {
  List<String> errors = [];
}

// Level 7
abstract class AuditableEntity extends ValidatableEntity {
  String createdBy = '';
  String updatedBy = '';
}

// Level 8 - Finally a concrete class!
class DataModel extends AuditableEntity {
  double val = 0.0;
  String cat = '';
}

class BadCodeWidget extends StatefulWidget {
  @override
  _BadCodeWidgetState createState() => _BadCodeWidgetState();
}

class _BadCodeWidgetState extends State<BadCodeWidget> {
  // Multiple controllers for same purpose
  TextEditingController ctrl1 = TextEditingController();
  TextEditingController ctrl2 = TextEditingController();
  TextEditingController ctrl3 = TextEditingController();

  List<DataModel> items = [];
  String txt = '';  // Poor naming
  bool flg = false; // Poor naming
  int cnt = 0;      // Poor naming
  double val = 0.0; // Poor naming

  Timer? tmr;       // Poor naming
  HttpClient? client;

  @override
  void initState() {
    super.initState();

    // setState in initState - wrong!
    setState(() {
      flg = true;
    });

    // Expensive operations in initState
    for (int i = 0; i < 10000; i++) {
      globalData.add('Item $i');
    }

    // Resource leak - HttpClient never closed
    client = HttpClient();

    loadData();
    startInfiniteLoop();
  }

  // Missing dispose - memory leak!
  // Controllers not disposed

  void startInfiniteLoop() {
    // Infinite loop that blocks UI
    tmr = Timer.periodic(Duration(milliseconds: 10), (timer) {
      while (true) {  // Infinite loop!
        if (Random().nextBool()) {
          break; // This never happens reliably
        }
      }
    });
  }

  // Spaghetti code - 200+ lines method with no structure
  void processData(String action, {Map<String, dynamic>? params}) {
    // No error handling anywhere!

    if (action == 'load') {
      // Heavy computation in method that could be called from build
      for (int i = 0; i < 1000; i++) {
        double result = 0;
        for (int j = 0; j < 1000; j++) {
          result += sin(i * j * 3.14159 / 180); // Magic number!
        }
        val += result;
      }

      if (params != null && params.containsKey('force')) {
        if (params['force'] == true) {
          items.clear();
          for (int i = 0; i < 20; i++) { // Magic number!
            DataModel item = DataModel();
            item.id = 'item_' + i.toString(); // Manual concatenation!
            item.name = 'Item ' + i.toString(); // Manual concatenation!
            // Copy-pasted inline logic #1
            int tempId = i;
            tempId = (tempId * 42).toInt(); // Magic number!
            String formattedId = tempId.toString() + '!'; // Manual concatenation!
            item.desc = formattedId;
            item.val = Random().nextDouble() * 100; // Magic number!
            item.cat = i % 3 == 0 ? 'A' : i % 3 == 1 ? 'B' : 'C'; // Magic numbers!
            items.add(item);
          }
          // Redundant setState - no actual changes sometimes
          setState(() {});
          setState(() {}); // Multiple setState calls
          setState(() {});
        } else {
          if (items.length < 5) { // Magic number!
            processData('load', params: {'force': true}); // Self-calling creates goto-like behavior
            return;
          } else {
            if (Random().nextBool()) { // Unpredictable UI behavior!
              processData('filter', params: {'text': 'random'});
              processData('sort', params: {'field': 'value'});
            } else {
              processData('reset');
              processData('load', params: {'force': true});
            }
          }
        }
      } else {
        processData('load', params: {'force': true});
      }

    } else if (action == 'filter') {
      if (params == null || !params.containsKey('text')) {
        txt = '';
      } else {
        String filterText = params['text'];
        if (filterText.isNotEmpty) {
          List<DataModel> filtered = [];
          // Inefficient algorithm - O(n²) when could be O(n)
          for (DataModel item in items) {
            for (String keyword in filterText.split(' ')) {
              if (item.name.toLowerCase().contains(keyword.toLowerCase())) {
                if (!filtered.contains(item)) { // Inefficient contains check
                  filtered.add(item);
                }
              }
            }
          }
          setState(() {
            items = filtered;
          });
          if (filtered.isEmpty) {
            processData('message', params: {'text': 'No results found'});
          }
        } else {
          processData('reset');
        }
      }

    } else if (action == 'process') {
      for (int i = 0; i < items.length; i++) {
        // Copy-pasted inline logic #2 (same as #1)
        int tempId = i;
        tempId = (tempId * 42).toInt();
        String formattedId = tempId.toString() + '!';

        // Unmotivated delay
        Future.delayed(Duration(milliseconds: 200 + i * 50), () { // Magic numbers!
          // Missing mounted check!
          setState(() {
            txt = 'Processing: ' + formattedId; // Manual concatenation!
          });
        });
      }

    } else if (action == 'network') {
      // Missing error handling for network operations
      client?.get('example.com', 80, '/api/data') // This will fail!
          .then((request) => request.close())
          .then((response) {
        // Process response without error handling
        response.transform(utf8.decoder).listen((data) {
          setState(() {
            txt = 'Data: ' + data; // Manual concatenation!
          });
        });
      });

    } else if (action == 'sort') {
      if (params != null && params.containsKey('field')) {
        String field = params['field'];
        if (field == 'name') {
          // Inefficient sorting - could use built-in sort
          for (int i = 0; i < items.length - 1; i++) {
            for (int j = i + 1; j < items.length; j++) {
              if (items[i].name.compareTo(items[j].name) > 0) {
                DataModel temp = items[i];
                items[i] = items[j];
                items[j] = temp;
              }
            }
          }
        }
        setState(() {});
      }

    } else if (action == 'message') {
      if (params != null && params.containsKey('text')) {
        // Missing mounted check before using context!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(params['text'])),
        );
      }

    } else if (action == 'reset') {
      setState(() {
        cnt = 0;
        txt = '';
        flg = false;
        globalCounter = 0; // Modifying global state
        globalMessage = ''; // Modifying global state
      });
      processData('load', params: {'force': true});

    } else {
      // Debug info shown to user!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debug: Unknown action $action')),
      );
    }
  }

  // Duplicated method #1 (same functionality as processSpecialData)
  void handleSpecialCase() {
    for (int i = 0; i < items.length; i++) {
      // Copy-pasted inline logic #3 (same as #1 and #2)
      int tempId = i;
      tempId = (tempId * 42).toInt();
      String formattedId = tempId.toString() + '!';

      if (items[i].val > 50) { // Magic number!
        items[i].desc = 'High: ' + formattedId; // Manual concatenation!
      } else {
        items[i].desc = 'Low: ' + formattedId; // Manual concatenation!
      }
    }
    setState(() {});
  }

  // Duplicated method #2 (same functionality as handleSpecialCase)
  void processSpecialData() {
    for (int i = 0; i < items.length; i++) {
      // Copy-pasted inline logic #4 (same as others)
      int tempId = i;
      tempId = (tempId * 42).toInt();
      String formattedId = tempId.toString() + '!';

      if (items[i].val > 50) {
        items[i].desc = 'High: ' + formattedId;
      } else {
        items[i].desc = 'Low: ' + formattedId;
      }
    }
    setState(() {});
  }

  void loadData() {
    processData('load', params: {'force': true});
  }

  @override
  Widget build(BuildContext context) {
    // Heavy computation in build() - recalculated every rebuild!
    double heavyCalculation = 0;
    for (int i = 0; i < 1000; i++) {
      heavyCalculation += sqrt(i * 123.456); // Magic number!
    }

    // Object creation in build() - created every rebuild!
    final expensiveObject = DataModel();
    expensiveObject.name = 'Expensive Object ' + cnt.toString(); // Manual concatenation!

    return Scaffold(
      appBar: AppBar(
        title: Text('Bad Code Demo'),
        backgroundColor: Color(0xFF2196F3), // Magic number color!
      ),
      body: Column(
        children: [
          // Copy-pasted UI component #1
          Container(
            margin: EdgeInsets.all(8.0), // Magic number!
            padding: EdgeInsets.all(12.0), // Magic number!
            height: 80, // Fixed size instead of responsive!
            decoration: BoxDecoration(
              color: Color(0xFFFFEB3B), // Magic number color!
              borderRadius: BorderRadius.circular(8), // Magic number!
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => processData('load'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63), // Magic number color!
                    padding: EdgeInsets.all(12), // Magic number!
                  ),
                  child: Text(
                    'Load',
                    style: TextStyle(fontSize: 14), // Magic number!
                  ),
                ),
                SizedBox(width: 16), // Magic number!
                ElevatedButton(
                  onPressed: () => processData('sort', params: {'field': 'name'}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63), // Repeated style!
                    padding: EdgeInsets.all(12), // Repeated style!
                  ),
                  child: Text(
                    'Sort',
                    style: TextStyle(fontSize: 14), // Repeated style!
                  ),
                ),
              ],
            ),
          ),

          // Copy-pasted UI component #2 (almost identical to #1)
          Container(
            margin: EdgeInsets.all(8.0), // Same magic numbers!
            padding: EdgeInsets.all(12.0), // Same magic numbers!
            height: 80, // Same fixed size!
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50), // Different magic number color!
              borderRadius: BorderRadius.circular(8), // Same magic number!
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => processData('filter', params: {'text': 'test'}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63), // Same repeated style!
                    padding: EdgeInsets.all(12), // Same repeated style!
                  ),
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 14), // Same repeated style!
                  ),
                ),
                SizedBox(width: 16), // Same magic number!
                ElevatedButton(
                  onPressed: () => processData('process'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63), // Same repeated style!
                    padding: EdgeInsets.all(12), // Same repeated style!
                  ),
                  child: Text(
                    'Process',
                    style: TextStyle(fontSize: 14), // Same repeated style!
                  ),
                ),
              ],
            ),
          ),

          // TextField without controller (missing TextEditingController)
          Container(
            padding: EdgeInsets.all(16), // Magic number!
            child: TextField(
              // No controller! Should use ctrl1, ctrl2, or ctrl3
              decoration: InputDecoration(
                hintText: 'Enter text...',
              ),
              onChanged: (value) {
                // Race condition - multiple rapid changes
                Future.delayed(Duration(milliseconds: 100), () { // Magic number!
                  setState(() {
                    txt = value;
                  });
                });
                Future.delayed(Duration(milliseconds: 50), () { // Magic number!
                  setState(() {
                    globalMessage = value; // Global state modification
                  });
                });
              },
            ),
          ),

          // Debug info shown to user!
          Container(
            padding: EdgeInsets.all(8), // Magic number!
            child: Text(
              'Debug: Items=${items.length}, Counter=$cnt, Global=$globalCounter', // Debug info!
              style: TextStyle(
                fontSize: 12, // Magic number!
                color: Color(0xFF757575), // Magic number color!
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                // Object creation in build() itemBuilder
                final itemWidget = Container(
                  margin: EdgeInsets.all(4), // Magic number!
                  padding: EdgeInsets.all(8), // Magic number!
                  height: 60, // Fixed size!
                  decoration: BoxDecoration(
                    color: items[index].cat == 'A'
                        ? Color(0xFFFFCDD2) // Magic number!
                        : items[index].cat == 'B'
                        ? Color(0xFFC8E6C9) // Magic number!
                        : Color(0xFFBBDEFB), // Magic number!
                    borderRadius: BorderRadius.circular(4), // Magic number!
                  ),
                  child: Text(
                    items[index].name + ' - ' + items[index].val.toStringAsFixed(2), // Manual concatenation!
                    style: TextStyle(fontSize: 16), // Magic number!
                  ),
                );
                return itemWidget;
              },
            ),
          ),
        ],
      ),
    );
  }
}