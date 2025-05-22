import '/ui/pages/widgets/custom_match_card.dart';
import '/ui/pages/viewmodel/match_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<MatchViewModel>().fetchUserMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchViewModel = Provider.of<MatchViewModel>(context, listen: false);
    final matches = matchViewModel.matches;

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return CustomMatchCard(match: match);
                },
        ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
