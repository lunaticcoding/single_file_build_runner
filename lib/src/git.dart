import 'dart:io';

import 'generator.dart';

class Git {
  static Future<int> restoreDeletedFiles({required String filename, required List<Generator> generators}) async {
    final result = await Process.run('git', ['diff', '--name-only']);

    final filesToReset = result.stdout
        .toString()
        .split('\n')
        .where((file) => generators.any((generator) => file.endsWith('.${generator.extension}.dart')))
        .where((file) => !file.startsWith(filename.split('.').first))
        .where((file) => file != filename)
        .toList();

    await Process.run('git', ['checkout', ...filesToReset]);
    return filesToReset.length;
  }
}
