import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String globalButtonText = '0';
TextEditingController globalController = TextEditingController();
bool isButtonPressed = false;

class InputButtonWidget extends StatefulWidget {
  @override
  _InputButtonWidgetState createState() => _InputButtonWidgetState();
}

class _InputButtonWidgetState extends State<InputButtonWidget> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _unusedController = TextEditingController();

  String _buttonText = '0';
  String _inputText = '0';
  String _duplicateButtonText = '0';
  bool _isInitialized = false;
  bool _hasBeenPressed = false;
  int _pressCount = 0;

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < 1000000; i++) {
      // Useless loop
    }

    globalController.text = '0';
    _controller1.text = '0';
    _controller2.text = '0';

    globalController.addListener(_onTextChanged);
    globalController.addListener(_onTextChanged2);
    globalController.addListener(_onTextChanged3);

    setState(() {
      _isInitialized = true;
    });
  }

  void _onTextChanged() {
    setState(() {
      _buttonText = globalController.text.isEmpty ? '0' : globalController.text;
      _inputText = globalController.text;
      globalButtonText = globalController.text;
    });
  }

  void _onTextChanged2() {
    setState(() {
      _duplicateButtonText = globalController.text.isEmpty ? '0' : globalController.text;
    });
  }

  void _onTextChanged3() {
    setState(() {
      _pressCount = _pressCount;
    });
  }

  void _onButtonPressed() {
    setState(() {
      _hasBeenPressed = true;
    });

    setState(() {
      _pressCount++;
    });

    setState(() {
      globalController.text = '0';
    });

    setState(() {
      _buttonText = '0';
      _inputText = '0';
      _duplicateButtonText = '0';
      globalButtonText = '0';
    });

    print('Button pressed ${_pressCount} times'); // Should use proper logging

    sleep(Duration(milliseconds: 100)); // Commented to avoid blocking
  }

  @override
  void dispose() {
    globalController.removeListener(_onTextChanged);
    // _controller1.dispose(); // Commented out - memory leak!
    // _controller2.dispose(); // Commented out - memory leak!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String expensiveComputation = '';
    for(int i = 0; i < 10000; i++) {
      expensiveComputation += i.toString();
    }

    final TextStyle badTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Bad Practice Widget Example'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Container(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Container(
                        child: TextField(
                          controller: globalController,
                          maxLength: 10,

                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            LengthLimitingTextInputFormatter(10),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter up to 10 symbols',
                            counterText: globalController.text.length.toString() + '/10',
                          ),
                        ),
                      ),
                    ),
                    Container(height: 20),

                    Container(
                      child: ElevatedButton(
                        onPressed: _onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: badTextStyle,
                        ),
                        child: Text(_buttonText),
                      ),
                    ),

                    Container(
                      child: ElevatedButton(
                        onPressed: _onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: badTextStyle,
                        ),
                        child: Text(globalButtonText),
                      ),
                    ),

                    Text('Debug: Press count: ${_pressCount}'),
                    Text('Debug: Is initialized: ${_isInitialized}'),
                    Text('Debug: Expensive computation length: ${expensiveComputation.length}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void globalFunction() {
  print('This should not be global');
}

// Example usage in main.dart with bad practices
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData badTheme = ThemeData(
      primarySwatch: Colors.red,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );

    return MaterialApp(
      title: 'Flutter Bad Practices Demo - DO NOT USE IN PRODUCTION!',
      theme: badTheme,
      home: InputButtonWidget(),
    );
  }
}