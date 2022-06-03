import '../types.dart';

class ResponseResultListAndCount<T> {
  late final Iterable<T> list;
  late final int skip;
  late final int count;
  late final int page;
  late final int pages;

  ResponseResultListAndCount(
    Map<String, dynamic> result,
    TypeHydrator<T> hydrate,
  ) {
    skip = result['skip'] as int;
    count = result['count'] as int;
    page = result['page'] as int;
    pages = result['pages'] as int;
    list = result['list'].map((val) => hydrate(val));
  }
}
