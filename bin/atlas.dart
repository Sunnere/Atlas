import 'dart:io';

import 'package:atlas/core/models/repository_snapshot.dart';
import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/doctor/doctor_command.dart';
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
      await _runDoctor(
        _repositoryRoot(args),
      );
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

Future<RepositorySnapshot> _buildSnapshot(String root) async {
  final scanner = RepositoryScanner();

  final repository = await scanner.scan(root);

  return const RepositorySnapshotBuilder().build(
    repository,
    imports: scanner.imports,
    inventory: scanner.inventory,
  );
}

Future<void> _runScan(String root) async {
  print('Atlas Repository Scanner');
  print('');

  final snapshot = await _buildSnapshot(root);
  final model = snapshot.repository;

  print('Repository : ${model.rootPath}');
  print('Files      : ${model.totalFiles}');
  print('Directories: ${model.totalDirectories}');
  print('Imports    : ${snapshot.imports.length}');
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

Future<void> _runDoctor(String root) async {
  final snapshot = await _buildSnapshot(root);

  const DoctorCommand().run(
    repository: snapshot.repository,
    imports: snapshot.imports,
  );
}

void _printHelp() {
  print('Atlas Engineering OS');
  print('');
  print('Usage:');
  print('  dart run bin/atlas.dart scan [path]');
  print('  dart run bin/atlas.dart doctor [path]');
  print('  dart run bin/atlas.dart help');
}
