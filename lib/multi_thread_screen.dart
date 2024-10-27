import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MultiTaskScreen extends StatefulWidget {
  const MultiTaskScreen({super.key});

  @override
  _MultiTaskScreenState createState() => _MultiTaskScreenState();
}

class _MultiTaskScreenState extends State<MultiTaskScreen> {
  late ReceivePort primePort;
  late ReceivePort downloadPort;
  String? primeResult;
  String? downloadResult;

  @override
  void initState() {
    super.initState();
    startPrimeCalculation();
    startFileDownload();
  }

  @override
  void dispose() {
    primePort.close();
    downloadPort.close();
    super.dispose();
  }

  void startPrimeCalculation() {
    primePort = ReceivePort();
    Isolate.spawn(findPrimeCountIsolate, primePort.sendPort);
    primePort.listen((message) {
      setState(() {
        primeResult = 'Prime count: $message';
      });
    });
  }

  void startFileDownload() {
    downloadPort = ReceivePort();
    Isolate.spawn(downloadFileIsolate, downloadPort.sendPort);
    downloadPort.listen((message) {
      setState(() {
        downloadResult = message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Isolate Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            primeResult != null
                ? Text(primeResult!)
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            downloadResult != null
                ? Text(downloadResult!)
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// Isolate entry function for finding prime count
void findPrimeCountIsolate(SendPort sendPort) {
  int count = findPrimeCount(100000);
  sendPort.send(count);
}

int findPrimeCount(int max) {
  int count = 0;
  for (int i = 2; i < max; i++) {
    if (isPrime(i)) count++;
  }
  return count;
}

bool isPrime(int number) {
  for (int i = 2; i * i <= number; i++) {
    if (number % i == 0) return false;
  }
  return true;
}

// Isolate entry function for file download simulation
void downloadFileIsolate(SendPort sendPort) async {
  await Future.delayed(Duration(seconds: 5)); // Simulating download delay
  sendPort.send("File downloaded successfully!");
}
