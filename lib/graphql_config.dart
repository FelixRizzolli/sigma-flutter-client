import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink(
    'https://sigma-api-li68.onrender.com/'
  );

  GraphQLClient graphqlClient() => GraphQLClient(
    link: httpLink, 
    cache: GraphQLCache()
  );
}