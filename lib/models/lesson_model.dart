class LessonModel {
  String title;
  int number;
  List content;

  LessonModel({
    required this.title, 
    required this.number,
    required this.content
  });

  static LessonModel fromMap({ required Map map }) {
    final lessonModel = LessonModel(
      title: map['title'], 
      number: map['number'],
      content: List.empty()
    );
    List rawContent = map['content'];
    lessonModel.content = rawContent.map((lessonContentObject) => lessonContentObjectFromMap(map: lessonContentObject)).toList();
    return lessonModel;
  }

  static LessonContentObject lessonContentObjectFromMap({ required Map map }) {
    LessonContentObject contentObject = LessonParagraph(paragraph: "");
    switch (map['_type']) {
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