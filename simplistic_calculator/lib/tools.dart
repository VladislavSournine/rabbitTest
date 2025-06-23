import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Race Condition Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RaceConditionDemo(),
    );
  }
}

class RaceConditionDemo extends StatefulWidget {
  @override
  _RaceConditionDemoState createState() => _RaceConditionDemoState();
}

class _RaceConditionDemoState extends State<RaceConditionDemo> {
  int counter = 0;
  String result = '';
  bool isLoading = false;

  Future<void> incrementCounterUnsafe() async {
    int currentValue = counter;

    await Future.delayed(Duration(milliseconds: Random().nextInt(100) + 50));

    setState(() {
      counter = currentValue + 1;
    });
  }

  Future<String> unsafeDataOperation(String operationId) async {
    String currentData = result;

    await Future.delayed(Duration(milliseconds: Random().nextInt(200) + 100));

    String newData = currentData + '$operationId ';

    setState(() {
      result = newData;
    });

    return newData;
  }

  void startRaceCondition() {
    setState(() {
      isLoading = true;
      counter = 0;
      result = '';
    });

    for (int i = 0; i < 5; i++) {
      incrementCounterUnsafe();
    }

    for (int i = 1; i <= 3; i++) {
      unsafeDataOperation('Op$i');
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool _isCounterLocked = false;

  Future<void> incrementCounterSafe() async {
    if (_isCounterLocked) return; // Простий lock

    _isCounterLocked = true;

    try {
      int currentValue = counter;
      await Future.delayed(Duration(milliseconds: Random().nextInt(100) + 50));

      setState(() {
        counter = currentValue + 1;
      });
    } finally {
      _isCounterLocked = false;
    }
  }

  void startSafeOperation() {
    setState(() {
      isLoading = true;
      counter = 0;
      result = 'Safe: ';
    });

    // Запускаємо операції послідовно
    Future.wait([
      for (int i = 0; i < 5; i++) incrementCounterSafe(),
    ]).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Race Condition Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Counter: $counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Result: $result',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 16),
                    if (isLoading)
                      CircularProgressIndicator()
                    else
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: startRaceCondition,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Запустити Race Condition'),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: startSafeOperation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Безпечна операція'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Опис проблеми:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Race condition виникає коли декілька операцій намагаються змінити один ресурс одночасно\n'
                          '• У цьому прикладі counter може не досягти очікуваного значення 5\n'
                          '• Результати операцій можуть перезаписувати один одного\n'
                          '• Поведінка стає непередбачуваною',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}