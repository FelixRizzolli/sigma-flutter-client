import 'dart:ffi';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sigma_flutter_client/graphql_config.dart';
import 'package:sigma_flutter_client/models/lesson_model.dart';

class GraphQLService {
  static GraphQLConfig graphqlConfig = GraphQLConfig();
  GraphQLClient client = graphqlConfig.graphqlClient();
  
  Future<LessonModel> getLessonByNumber({
    required String lessonCollectionId,
    required int lessonNumber
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            query GetLessons(\$lessonCollectionId: ID!, \$lessonNumber: Int) {
              getLessonByNumber(lessonCollectionId: \$lessonCollectionId, lessonNumber: \$lessonNumber) {
                id
                title
                lessonNumber
                content {
                  ... on LessonQuote {
                    type
                    quote
                    author
                    source
                  }
                  ... on LessonList {
                    type
                    intro
                    list
                  }
                  ... on LessonParagraph {
                    type
                    paragraph
                  }
                }
              }
            }
          """),
          variables: {
            'lessonCollectionId': lessonCollectionId,
            'lessonNumber': lessonNumber,
          }
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        Map res = result.data?['getLessonByNumber'];

        if (res.isEmpty) {
          return LessonModel(title: ' ', lessonNumber: 0, content: []);
        }
        
        return LessonModel.fromMap(map: res);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
  
  Future<List<LessonCollectionModel>> getLessonCollections() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            query GetLessonCollections {
              getLessonCollections {
                id,
                name,
                frequency
              }
            }
          """)
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? resultList = result.data?['getLessonCollections'];

        if (resultList == null || resultList.isEmpty) {
          return [];
        }
        List<LessonCollectionModel> lessonCollections = [];
        for (var lessonCollectionDocument in resultList) {
          lessonCollections.add(LessonCollectionModel.fromMap(map: lessonCollectionDocument));
        }
        return lessonCollections;
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}