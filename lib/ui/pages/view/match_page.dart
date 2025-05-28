import '/domain/models/match_model.dart';
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
    // Carica i match dopo il primo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchViewModel>().fetchUserMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildBody(),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  Widget _buildBody() {
    return Consumer<MatchViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return _buildLoading();
        }
        if (viewModel.matches.isEmpty) {
          return _buildEmptyState();
        }

        return _buildMatchList(viewModel.matches);
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.black),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        children: [
          Text(
            'Nessun match disponibile. Prova a crearne uno:',
            style: TextStyle(fontSize: 18),
          ),
        ]
      ),
    );
  }

  Widget _buildMatchList(List<PongMatch> matches) {
    return RefreshIndicator(
      onRefresh: () => context.read<MatchViewModel>().fetchUserMatches(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: matches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final match = matches[index];
          return CustomMatchCard(match: match);
        },
      ),
    );
  }
}