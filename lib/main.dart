import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const TapNumberGame());
}

class TapNumberGame extends StatelessWidget {
  const TapNumberGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tap the Number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TapNumberGamePage(),
    );
  }
}

class TapNumberGamePage extends StatefulWidget {
  const TapNumberGamePage({super.key});

  @override
  TapNumberGamePageState createState() => TapNumberGamePageState();
}

class TapNumberGamePageState extends State<TapNumberGamePage> {
  List<int> numbers = [];
  int currentNumber = 1;
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _generateNumbers() {
    numbers.clear();
    for (int i = 1; i <= 25; i++) {
      numbers.add(i);
    }
    numbers.shuffle();
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer.cancel();
        _isRunning = false;
        _elapsedSeconds = 0;
        currentNumber = 1;
      } else {
        _startTimer();
        _isRunning = true;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _handleTap(int tappedNumber) {
    if (_isRunning && tappedNumber == currentNumber + 1) {
      setState(() {
        currentNumber++;
      });
    }
    if (currentNumber == 25) {
      _timer.cancel();
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Text('You completed the game in $_elapsedSeconds seconds.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap the Number'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tap the numbers in ascending order!',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: numbers.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _handleTap(numbers[index]),
                    child: Container(
                      color: numbers[index] <= currentNumber && _isRunning
                          ? Colors.green
                          : Colors.grey,
                      child: Center(
                        child: Text(
                          '${numbers[index]}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time: $_elapsedSeconds seconds',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          ElevatedButton(
            onPressed: _toggleTimer,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  _isRunning ? Colors.red : Colors.green),
            ),
            child: Text(
              _isRunning ? 'Stop' : 'Start',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
