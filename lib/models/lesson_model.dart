class LessonModel {
  final String title;
  final int number;

  LessonModel({
    required this.title, 
    required this.number
  });

  static LessonModel fromMap({ required Map map }) => LessonModel(
    title: map['title'], 
    number: map['number']
  );
}