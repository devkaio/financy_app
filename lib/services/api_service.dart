abstract class ApiService<T, R> {
  Future<R> create({
    required String path,
    Map<String, dynamic>? params,
  });

  Future<R> read({
    required String path,
    Map<String, dynamic>? params,
  });

  Future<R> update({
    required String path,
    Map<String, dynamic>? params,
  });

  Future<R> delete({
    required String path,
    Map<String, dynamic>? params,
  });
}
