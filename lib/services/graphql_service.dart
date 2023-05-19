import 'package:graphql_flutter/graphql_flutter.dart';

import '../data/exceptions.dart';
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
      getToken: () async {
        final result = await authService.userToken();

        return 'Bearer ${result.data}';
      },
    );

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      defaultPolicies: DefaultPolicies(
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
        query: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
      ),
      cache: GraphQLCache(store: HiveStore()),
    );

    return this;
  }

  @override
  Future<QueryResult> create({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final options = MutationOptions(
        variables: params,
        document: gql(path),
      );

      final result = await client.mutate(options);
      if (result.hasException) {
        throw result.exception!;
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResult> read({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final options = QueryOptions(
        variables: params,
        document: gql(path),
      );

      final cacheResult = client.readQuery(options.asRequest);
      final result = await client.query(options);

      if (result.hasException && _containsInvalidResult(result)) {
        throw const AuthException(code: 'session-expired');
      }

      if (result.data != null && !result.hasException) {
        return result;
      } else {
        return QueryResult(
          options: options,
          source: QueryResultSource.cache,
          data: cacheResult,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResult> update({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final options = MutationOptions(
        variables: params,
        document: gql(path),
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResult> delete({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final options = MutationOptions(
        document: gql(path),
        variables: params,
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

bool _containsInvalidResult(QueryResult result) {
  final List<GraphQLError> graphqlErrors = result.exception!.graphqlErrors;

  if (graphqlErrors.isNotEmpty) {
    final Map<String, dynamic>? errorExtensions =
        graphqlErrors.first.extensions;

    return errorExtensions != null &&
        ['invalid-jwt', 'invalid-headers'].any(errorExtensions.containsValue);
  }
  return false;
}
