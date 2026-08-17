import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'canonical_evidence.dart';

class EvidenceIdentity {
  const EvidenceIdentity({
    required this.algorithm,
    required this.value,
  });

  factory EvidenceIdentity.from(CanonicalEvidence evidence) {
    final bytes = utf8.encode(evidence.canonicalJson);
    final digest = sha256.convert(bytes);

    return EvidenceIdentity(
      algorithm: 'sha256',
      value: digest.toString(),
    );
  }

  final String algorithm;
  final String value;
}
