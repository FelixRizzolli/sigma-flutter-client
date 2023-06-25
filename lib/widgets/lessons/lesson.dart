import 'package:flutter/material.dart';
import 'package:sigma_flutter_client/graphql_service.dart';
import 'package:sigma_flutter_client/models/lesson_model.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.title});

  final String title;

  @override
  State<LessonPage> createState() => _LessonPageState();
}


class _LessonPageState extends State<LessonPage> {
  final GraphQLService _graphQLService = GraphQLService();
  List<LessonModel> _lessons = List.empty();
  
  int _counter = 1;
  LessonModel _selectedLesson = LessonModel(title: "", number: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    try {
      _lessons = await _graphQLService.getLessons(lessonCollectionId: "64947fed85956572222a0b76");
      _selectedLesson = _lessons.elementAt(_counter - 1);
    } catch (error) {
      _lessons = List.empty();
    }
    setState(() {});
  }

  void _incrementCounter() {
    if (_lessons.isEmpty) {
      _load();
    } else {
      setState(() {
        _counter++;

        if (_counter > _lessons.length) _counter = 1;

        _selectedLesson = _lessons.elementAt(_counter - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: (_lessons.isEmpty)
          ? <Widget>[
              const Center(child: CircularProgressIndicator())
            ]
          : <Widget>[
              Text(
                '(${_counter}) ${_selectedLesson.title}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '"${_selectedLesson.title}"',
                style: const TextStyle(
                  fontWeight: FontWeight.w100,
                  fontStyle: FontStyle.italic
                ),
              ),
            ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}