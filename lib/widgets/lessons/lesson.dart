import 'package:flutter/material.dart';
import 'package:sigma_flutter_client/graphql_service.dart';
import 'package:sigma_flutter_client/models/lesson_model.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lessonCollection});

  final LessonCollectionModel lessonCollection;

  @override
  State<LessonPage> createState() => _LessonPageState();
}


class _LessonPageState extends State<LessonPage> {
  final GraphQLService _graphQLService = GraphQLService();
  LessonModel _lesson = LessonModel(title: ' ', lessonNumber: 0, content: List.empty());
  
  int _counter = 1;
  String _day = ' ';
  late LessonModel _selectedLesson;

  @override
  void initState() {
    super.initState();
    final dayOfTheYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1, 0, 0)).inDays + 1;
    _counter = dayOfTheYear;
    _load();
  }

  void _load() async {
    try {
      _lesson = await _graphQLService.getLessonByNumber(lessonCollectionId: widget.lessonCollection.id, lessonNumber: _counter);
      _day = setDayString();
    } catch (error) {
      if (_counter == 1) {
        _lesson = LessonModel(title: ' ', lessonNumber: 0, content: List.empty());
      } else {
        _counter = 1;
        _load();
      }
    }
    setState(() {
      _selectedLesson = _lesson;
    });
  }

  void _incrementCounter() {
    _counter++;
    _load();
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
      } else if (contentObject is LessonUnorderedList) {
        if (contentObject.intro != null) {
          contentObjects.add(
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                contentObject.intro ?? '',
                textAlign: TextAlign.justify,
              ),
            )
          );
        }
        for (var listElement in contentObject.list) {
          //
        }
      } else if (contentObject is LessonOrderedList) {
        if (contentObject.intro != null) {
          contentObjects.add(
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                contentObject.intro ?? '',
                textAlign: TextAlign.justify,
              ),
            )
          );
        }
        for (var listElement in contentObject.list) {
          //
        }
      }
    }
    return contentObjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Daily Lesson'),
      ),
      body: (_lesson.lessonNumber == 0)
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