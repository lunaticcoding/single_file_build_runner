abstract class Generator {
  String get extension;

  void build({required StringBuffer buffer, required String filename});

  static FreezedGenerator freezed() => FreezedGenerator();

  static Generator fromName(String name) {
    switch (name) {
      case 'freezed':
        return FreezedGenerator();
      default:
        throw Exception('Generator $name does not exist. Did you maybe misspell it?');
    }
  }
}

class FreezedGenerator extends Generator {
  @override
  String get extension => 'freezed';

  @override
  void build({required StringBuffer buffer, required String filename}) {
    buffer.writeln('      freezed:freezed:');
    buffer.writeln('        enabled: true');
    buffer.writeln('        generate_for:');
    buffer.writeln('          include:');
    buffer.writeln('            - $filename');
  }
}
