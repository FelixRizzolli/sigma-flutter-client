class LessonCollectionModel {
  String id;
  String name;
  String frequency;

  LessonCollectionModel({
    required this.id,
    required this.name,
    required this.frequency
  });

  static LessonCollectionModel fromMap({ required Map map }) {
    return LessonCollectionModel(
      id: map['id'],
      name: map['name'], 
      frequency: map['frequency']
    );
  }
}
class LessonModel {
  String title;
  int lessonNumber;
  List content;

  LessonModel({
    required this.title, 
    required this.lessonNumber,
    required this.content
  });

  static LessonModel fromMap({ required Map map }) {
    final lessonModel = LessonModel(
      title: map['title'], 
      lessonNumber: map['lessonNumber'],
      content: List.empty()
    );
    List rawContent = map['content'];
    lessonModel.content = rawContent.map((lessonContentObject) => lessonContentObjectFromMap(map: lessonContentObject)).toList();
    return lessonModel;
  }

  static LessonContentObject lessonContentObjectFromMap({ required Map map }) {
    LessonContentObject contentObject = LessonParagraph(paragraph: "");
    switch (map['type']) {
      case "QUOTE": {
        contentObject = LessonQuote(
          quote: map['quote'],
          source: map['source'],
          author: map['author']
        );
      }
      case "PARAGRAPH": {
        contentObject = LessonParagraph(
          paragraph: map['paragraph']
        );
      }
      case "ORDEREDLIST": {
        List<String> list = map['list'];
        contentObject = LessonUnorderedList(
          intro: map['intro'],
          list: list
        );
      }
      case "UNORDEREDLIST": {
        List<String> list = map['list'];
        contentObject = LessonOrderedList(
          intro: map['intro'],
          list: list
        );
      }
      default: contentObject = LessonParagraph(paragraph: "");
    }
    return contentObject;
  }
}

interface class LessonContentObject {
  final String type = "";
}
class LessonParagraph implements LessonContentObject {
  @override
  final String type;
  final String paragraph;

  LessonParagraph({
    this.type = "PARAGRAPH",
    required this.paragraph
  });

}
class LessonQuote implements LessonContentObject {
  @override
  final String type;
  final String quote;
  final String? source;
  final String? author;

  LessonQuote({
    this.type = "QUOTE",
    required this.quote,
    this.source,
    this.author
  });
}
class LessonUnorderedList implements LessonContentObject {
  @override
  final String type;
  final String? intro;
  final List<String> list;

  LessonUnorderedList({
    this.type = "UNORDEREDLIST",
    required this.list,
    this.intro
  });
}
class LessonOrderedList implements LessonContentObject {
  @override
  final String type;
  final String? intro;
  final List<String> list;

  LessonOrderedList({
    this.type = "ORDEREDLIST",
    required this.list,
    this.intro
  });
}