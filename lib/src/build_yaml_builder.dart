import 'package:single_file_build_runner/src/generator.dart';

class BuildYamlBuilder {
  final String filename;

  BuildYamlBuilder({required this.filename});

  String build(List<Generator> generators) {
    final buffer = StringBuffer();

    buffer.writeln('targets:');
    buffer.writeln('  \$default:');
    buffer.writeln('    builders:');

    for (final generator in generators) {
      generator.build(buffer: buffer, filename: filename);
    }

    return buffer.toString();
  }
}
