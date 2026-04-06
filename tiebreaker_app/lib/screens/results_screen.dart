import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../services/decision_service.dart';

class ResultScreen extends StatelessWidget{
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final result = Provider.of<DecisionService>(context).currentResult;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Analysis Results'),
            bottom: const TabBar(
                tabs: [
                  Tab(text: 'pros/cons'),
                  Tab(text: 'comparison'),
                  Tab(text: 'SWOT'),
                ],
            ),
          ),
          body: TabBarView(
              children: [
                Markdown(data: result!.prosAndCons),
                Markdown(data: result!.comparisonTable),
                Markdown(data: result!.swotAnalysis),
              ],
          ),
        ),
    );
  }
}