import 'package:flutter/material.dart';

import '../models/app_state.dart';
import 'pull_down.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppState state = AppState.success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pull Down Animation'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Expected Outcome:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            DropdownButton<AppState>(
              value: state,
              items: AppState.states
                  .map<DropdownMenuItem<AppState>>(
                    (e) => DropdownMenuItem<AppState>(
                      value: e,
                      child: Text(
                        e.title,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (AppState? newState) {
                setState(() {
                  state = newState!;
                });
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PullDownScreen(state: state)),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Launch',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
