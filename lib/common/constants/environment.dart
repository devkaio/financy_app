class Environment {
  const Environment();

  String get graphqlEndpoint =>
      const String.fromEnvironment('GRAPHQL_ENDPOINT');
}
