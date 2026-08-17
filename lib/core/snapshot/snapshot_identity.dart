import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'canonical_snapshot.dart';

class SnapshotIdentity {
  const SnapshotIdentity({
    required this.algorithm,
    required this.value,
  });

  factory SnapshotIdentity.from(CanonicalSnapshot snapshot) {
    final bytes = utf8.encode(snapshot.canonicalJson);
    final digest = sha256.convert(bytes);

    return SnapshotIdentity(
      algorithm: 'sha256',
      value: digest.toString(),
    );
  }

  final String algorithm;
  final String value;
}
