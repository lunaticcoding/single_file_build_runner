import 'dart:io';

import 'package:single_file_build_runner/src/build_yaml_builder.dart';
import 'package:single_file_build_runner/src/generator.dart';
import 'package:single_file_build_runner/src/git.dart';

Future<void> singleFileBuildRunner(String filename, {required List<Generator> generators}) async {
  final executingDirectory = Directory.current;

  final buildYaml = File('${executingDirectory.path}/build.yaml');
  final yamlCache = await buildYaml.exists() ? buildYaml.readAsStringSync() : null;

  print('Creating build_runner config...');
  final yamlContent = BuildYamlBuilder(filename: filename).build(generators);
  await buildYaml.writeAsString(yamlContent);

  print('Running build_runner...');
  final buildRunner = await Process.start(
    'flutter',
    ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    mode: ProcessStartMode.inheritStdio,
  );
  await buildRunner.exitCode;

  print('Restoring deleted files...');
  final fileLength = await Git.restoreDeletedFiles(filename: filename, generators: generators);
  print('Restored $fileLength files');

  print('Cleaning up...');
  buildYaml.deleteSync();
  if (yamlCache != null) {
    buildYaml.createSync();
    buildYaml.writeAsStringSync(yamlCache);
  }
  print('Finished with exit code 0');
}
