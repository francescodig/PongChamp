import 'package:flutter/material.dart';

class OrganisesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organises Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Ciao',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
