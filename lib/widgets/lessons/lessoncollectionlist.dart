import 'package:flutter/material.dart';
import 'package:sigma_flutter_client/graphql_service.dart';
import 'package:sigma_flutter_client/models/lesson_model.dart';

class LessonCollectionListPage extends StatefulWidget {
  const LessonCollectionListPage({super.key, required this.title});

  final String title;

  @override
  State<LessonCollectionListPage> createState() => _LessonCollectionListPageState();
}


class _LessonCollectionListPageState extends State<LessonCollectionListPage> {
  final GraphQLService _graphQLService = GraphQLService();
  List<LessonCollectionModel> _lessonCollections = List.empty();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    try {
      _lessonCollections = await _graphQLService.getLessonCollections();
    } catch (error) {
      _lessonCollections = List.empty();
    }
    setState(() {});
  }

  List<Widget> getList() {
    List<Widget> widgets = [];

    // => LessonCollections
    if (_lessonCollections.isNotEmpty) {
      for (LessonCollectionModel lessonColection in _lessonCollections) {
        widgets.add(
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    lessonColection.name,
                    textAlign: TextAlign.left,
                      style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                  Text(
                    lessonColection.frequency,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 8
                    ),
                  ),
                ], 
              ),
            )
          )
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: (_lessonCollections.isEmpty)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: const EdgeInsets.all(8),
            children: getList()
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _load,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}