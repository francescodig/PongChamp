import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class OrganisesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }
}
