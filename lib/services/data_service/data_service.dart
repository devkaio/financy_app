abstract class DataService<R> {
  Future<R> create({
    required String path,
    Map<String, dynamic> params = const {},
  });

  Future<R> read({
    required String path,
    Map<String, dynamic> params = const {},
  });

  Future<R> update({
    required String path,
    Map<String, dynamic> params = const {},
  });

  Future<R> delete({
    required String path,
    Map<String, dynamic> params = const {},
  });
}
