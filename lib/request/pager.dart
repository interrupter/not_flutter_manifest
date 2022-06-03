class NotPager {
  static const defaultSize = 10;
  static const defaultPage = 0;
  int _page = defaultPage;
  int _size = defaultSize;
  int _total = -1; //total pages count

  setTotal(int val) {
    _total = val;
  }

  setPage(int val) {
    _page = val;
  }

  setSize(int val) {
    _size = val;
  }

  void next() {
    _page++;
    if (_total > -1) {
      if (_page > _total - 1) {
        _page = _total - 1;
      }
    }
  }

  void prev() {
    _page--;
    if (_page < 0) {
      _page = 0;
    }
  }

  void first() {
    _page = 0;
  }

  void last() {
    _page = _total - 1;
  }

  int skip() {
    return _page * _size;
  }

  Map<String, int> toParams() {
    return {
      'size': _size,
      'page': _page,
    };
  }
}
