import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputButtonWidget extends StatefulWidget {
  @override
  _InputButtonWidgetState createState() => _InputButtonWidgetState();
}

class _InputButtonWidgetState extends State<InputButtonWidget> {
  final TextEditingController _controller = TextEditingController();
  String _buttonText = '0';

  @override
  void initState() {
    super.initState();
    _controller.text = '0';
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _buttonText = _controller.text.isEmpty ? '0' : _controller.text;
    });
  }

  void _onButtonPressed() {
    setState(() {
      _controller.text = '0';
      _buttonText = '0';
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Button Widget'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input field
            TextField(
              controller: _controller,
              maxLength: 10,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter up to 10 symbols',
                counterText: '${_controller.text.length}/10',
              ),
            ),
            SizedBox(height: 20),
            // Button
            ElevatedButton(
              onPressed: _onButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text(_buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage in main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Input Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputButtonWidget(),
    );
  }
}