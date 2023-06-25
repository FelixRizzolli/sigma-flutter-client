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
  String _day = ' ';
  LessonModel _selectedLesson = LessonModel(title: '', number: 0, content: List.empty());

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    try {
      _lessons = await _graphQLService.getLessons(lessonCollectionId: '64947fed85956572222a0b76');
      final dayOfTheYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1, 0, 0)).inDays;
      _counter = (_lessons.length >= dayOfTheYear) ? dayOfTheYear : 1;
      _day = setDayString();
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
        _day = setDayString();
      });
    }
  }

  String setDayString() {
    DateTime dateTime = DateTime(DateTime.now().year, 1, _counter, 0, 0);
    String dayString = '${dateTime.day}. ';
    switch (dateTime.month) {
      case 1: dayString += 'Januar';
      case 2: dayString += 'Februar';
      case 3: dayString += 'März';
      case 4: dayString += 'April';
      case 5: dayString += 'Mai';
      case 6: dayString += 'Juni';
      case 7: dayString += 'Juli';
      case 8: dayString += 'August';
      case 9: dayString += 'September';
      case 10: dayString += 'Oktober';
      case 11: dayString += 'November';
      case 12: dayString += 'Dezember';
    }
    return dayString;
  }

  List<Widget> getContentObjects() {
    List<Widget> contentObjects = [];
    for(var contentObject in _selectedLesson.content) {
      if (contentObject is LessonQuote) {
        contentObjects.add(
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child:
                  Text(
                  '«${contentObject.quote}»',
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic
                  ),
                  textAlign: TextAlign.justify,
                )
              ),              
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child:
                  Text(
                  '~ ${contentObject.author}, ${contentObject.source} ~',
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic
                  ),
                  textAlign: TextAlign.justify,
                )
              ),
            ],
          )
        );
      } else if (contentObject is LessonParagraph) {
        contentObjects.add(
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 
                  (contentObject == _selectedLesson.content.lastOrNull)
                    ? 64
                    : 8
                ),
                child: Text(
                  contentObject.paragraph,
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          )
        );
      }
    }
    return contentObjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: (_lessons.isEmpty)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                _day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                _selectedLesson.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24
                ),
              ),
              Column(
                children: getContentObjects(),
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