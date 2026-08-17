import 'evidence.dart';

class EvidenceLedger {
  final Map<String, Evidence> _evidence = {};

  int get length => _evidence.length;

  bool contains(String id) => _evidence.containsKey(id);

  Evidence? getById(String id) => _evidence[id];

  Iterable<Evidence> get all => List<Evidence>.unmodifiable(
        _evidence.values,
      );

  void add(Evidence evidence) {
    if (_evidence.containsKey(evidence.id)) {
      throw StateError(
        'Evidence with id "${evidence.id}" already exists.',
      );
    }

    _evidence[evidence.id] = evidence;
  }
}
