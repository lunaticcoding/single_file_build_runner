import 'dart:io';

import 'package:single_file_build_runner/single_file_build_runner.dart';
import 'package:single_file_build_runner/src/generator.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    throw Exception('Please pass the filename as argument');
  }

  final buildRunnerYaml = File('${Directory.current.path}/single_file_build_runner.yaml');
  if (arguments.length == 1 && !buildRunnerYaml.existsSync()) {
    throw Exception(
        'Please pass the list of generators as a second argument or create a single_file_build_runner.yaml file');
  }

  final filename = arguments[0];
  // TODO parse and decide format
  // final yaml = buildRunnerYaml.readAsStringSync();
  final generatorNames = arguments.length > 1 ? arguments.skip(1).toList() : [buildRunnerYaml.readAsStringSync()];
  final generators = generatorNames.map(Generator.fromName).toList();

  await singleFileBuildRunner(filename, generators: generators);
}
