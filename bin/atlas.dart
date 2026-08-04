import 'dart:io';

import 'package:atlas/scanner/repository_scanner.dart';

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? 'scan' : args.first;

  switch (command) {
    case 'scan':
      await _runScan(
        args.length > 1 ? args[1] : Directory.current.path,
      );
      break;

    case 'doctor':
      print('🏛 Atlas Engineering Doctor');
      print('');
      print('Doctor MVP is under construction.');
      print('');
      print('Run: dart run bin/atlas.dart scan');
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

Future<void> _runScan(String root) async {
  final scanner = RepositoryScanner();

  print('Atlas Repository Scanner');
  print('');

  final model = await scanner.scan(root);

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

void _printHelp() {
  print('Atlas Engineering OS');
  print('');
  print('Usage:');
  print('  dart run bin/atlas.dart scan [path]');
  print('  dart run bin/atlas.dart doctor');
  print('  dart run bin/atlas.dart help');
}
