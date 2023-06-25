import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sigma_flutter_client/graphql_config.dart';
import 'package:sigma_flutter_client/models/lesson_model.dart';

class GraphQLService {
  static GraphQLConfig graphqlConfig = GraphQLConfig();
  GraphQLClient client = graphqlConfig.graphqlClient();
  
  Future<List<LessonModel>> getLessons({
    required String lessonCollectionId
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            query GetLessons(\$lessonCollectionId: ID!) {
              getLessons(lessonCollectionId: \$lessonCollectionId) {
                title
                content {
                  _type
                  quote
                  source
                  author
                  paragraph
                }
                number
              }
            }
          """),
          variables: {
            'lessonCollectionId': lessonCollectionId
          }
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['getLessons'];

        if (res == null || res.isEmpty) {
          return [];
        }
        
        return res.map(
          (lesson) => LessonModel.fromMap(map: lesson)
        ).toList();
      }
    } catch (error) {
      throw Exception(error);
    }
  }


}