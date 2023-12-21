import 'dart:io';

String fixtureReader(String nameFile) =>
    File('test/fixture/$nameFile').readAsStringSync();
