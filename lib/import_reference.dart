import 'import_type.dart';

class ImportReference {
  const ImportReference({
    required this.source,
    required this.target,
    required this.type,
  });

  final String source;
  final String target;
  final ImportType type;

  @override
  String toString() => '$source -> $target ($type)';
}
