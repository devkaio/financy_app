import 'package:financy_app/common/constants/environment.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../common/data/data.dart';
import '../services.dart';

class GraphQLService implements DataService<Map<String, dynamic>> {
  GraphQLService({
    required this.authService,
  });

  final AuthService authService;

  late GraphQLClient _client;
  GraphQLClient get client => _client;

  Future<GraphQLService> init() async {
    final HttpLink httpLink = HttpLink(
      const Environment().graphqlEndpoint,
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
          fetch: FetchPolicy.noCache,
          error: ErrorPolicy.ignore,
        ),
        query: Policies(
          fetch: FetchPolicy.noCache,
          error: ErrorPolicy.ignore,
        ),
      ),
      cache: GraphQLCache(store: InMemoryStore()),
    );

    return this;
  }

  @override
  Future<Map<String, dynamic>> create({
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
      return result.data ?? {};
    } catch (e) {
      _handleException(e);

      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> read({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final options = QueryOptions(
        variables: params,
        document: gql(path),
      );

      final result = await client.query(options);

      if (result.hasException && _containsInvalidResult(result)) {
        throw const AuthException(code: 'session-expired');
      }

      return result.data ?? {};
    } catch (e) {
      _handleException(e);

      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> update({
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

      return result.data ?? {};
    } catch (e) {
      _handleException(e);

      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> delete({
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

      return result.data ?? {};
    } catch (e) {
      _handleException(e);

      return {};
    }
  }
}

bool _containsInvalidResult(QueryResult result) {
  final List<GraphQLError> graphqlErrors = result.exception!.graphqlErrors;

  if (graphqlErrors.isNotEmpty) {
    final Map<String, dynamic> errorExtensions =
        graphqlErrors.first.extensions ?? {};

    return ['invalid-jwt', 'invalid-headers']
        .any(errorExtensions.containsValue);
  }
  return false;
}

void _handleException(dynamic e) {
  if (e is OperationException && e.linkException != null) {
    throw const ConnectionException(code: 'connection-error');
  }

  if (e is OperationException && e.graphqlErrors.isNotEmpty) {
    throw APIException(
      code: 0,
      textCode: e.graphqlErrors.first.extensions?['code'],
    );
  }

  if (e is AuthException || e is CacheException) {
    throw e;
  }

  throw const GeneralException();
}
