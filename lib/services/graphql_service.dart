import 'package:graphql_flutter/graphql_flutter.dart';

import 'api_service.dart';
import 'auth_service.dart';

class GraphQLService implements ApiService<GraphQLClient, QueryResult> {
  GraphQLService({
    required this.authService,
  });

  final AuthService authService;

  late GraphQLClient _client;
  GraphQLClient get client => _client;

  Future<GraphQLService> init() async {
    await initHiveForFlutter();

    final HttpLink httpLink = HttpLink(
      'https://concrete-pangolin-58.hasura.app/v1/graphql',
    );

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer ${await authService.userToken}',
    );

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      defaultPolicies: DefaultPolicies(
        mutate: Policies(
          fetch: FetchPolicy.cacheFirst,
        ),
        query: Policies(
          fetch: FetchPolicy.cacheFirst,
        ),
      ),
      cache: GraphQLCache(store: HiveStore()),
    );

    return this;
  }

  @override
  Future<QueryResult> create({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await client.mutate(
        MutationOptions(
          variables: params ?? {},
          document: gql(path),
        ),
      );
    } on ServerException {
      throw Exception('No connection at this time. Try again later.');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResult> read({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await client.query(
        QueryOptions(
          variables: params ?? {},
          document: gql(path),
        ),
      );
    } on ServerException {
      throw Exception('No connection at this time. Try again later.');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResult> update({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await client.mutate(
        MutationOptions(
          variables: params ?? {},
          document: gql(path),
          onError: (error) => throw error as Object,
        ),
      );
    } on OperationException {
      throw Exception('No connection at this time. Try again later.');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResult> delete({
    required String path,
    Map<String, dynamic>? params,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
