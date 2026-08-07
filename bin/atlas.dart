import 'dart:io';

import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/scanner/repository_scanner.dart';

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? 'scan' : args.first;

  switch (command) {
    case 'scan':
      await _runScan(
        _repositoryRoot(args),
      );
      break;

    case 'doctor':
      _doctorNotAvailable();
      break;

    case 'help':
      _printHelp();
      break;

    default:
      stderr.writeln('Unknown command: $command');
      stderr.writeln('');
      _printHelp();
      exitCode = 64;
  }
}

String _repositoryRoot(List<String> args) {
  if (args.length > 1) {
    return args[1];
  }

  return Directory.current.path;
}

Future<void> _runScan(String root) async {
  final scanner = RepositoryScanner();

  print('Atlas Repository Scanner');
  print('');

  final repository = await scanner.scan(root);

  final snapshot = const RepositorySnapshotBuilder().build(
    repository,
  );

  final model = snapshot.repository;

  print('Repository : ${model.rootPath}');
  print('Files      : ${model.totalFiles}');
  print('Directories: ${model.totalDirectories}');
  print('');

  print('Languages');

  final languages = model.languages.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (final language in languages) {
    print(' - ${language.key}: ${language.value}');
  }

  print('');
  print('Completed in ${model.scanDuration.inMilliseconds} ms');
}

void _doctorNotAvailable() {
  print('🏛 Atlas Engineering Doctor');
  print('');
  print('Doctor is temporarily unavailable during the');
  print('migration from the legacy scanner to Atlas Core.');
  print('');
  print('Current status:');
  print('  ✓ New RepositoryScanner');
  print('  ✓ RepositorySnapshot');
  print('  ⏳ Doctor migration');
  print('');
}

void _printHelp() {
  print('Atlas Engineering OS');
  print('');
  print('Usage:');
  print('  dart run bin/atlas.dart scan [path]');
  print('  dart run bin/atlas.dart doctor');
  print('  dart run bin/atlas.dart help');
}
