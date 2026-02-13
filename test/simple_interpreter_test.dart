import 'package:code_pulse/logic/simple_interpreter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SimpleInterpreter', () {
    late SimpleInterpreter interpreter;

    setUp(() {
      interpreter = SimpleInterpreter();
    });

    // ... existing tests ...
    test('parses variable assignments with line tracking', () {
      const code = '''
      int a = 10;
      a = 20;
      ''';
      final steps = interpreter.interpret(code, 'Dart');
      expect(steps.length, 3);
      expect(steps[1].currentLine, 0);
      expect(steps[1].variables['a'], 10);
    });

    test('parses for-in loop correctly', () {
      const code = '''
      List<int> arr = [1, 2, 3];
      int sum = 0;
      for (var n in arr) {
        sum = sum + n;
      }
      ''';
      final steps = interpreter.interpret(code, 'Dart');
      expect(steps.last.variables['sum'], 6);
    });

    test('parses modulo operator in if condition', () {
      const code = '''
        List<int> arr = [1, 2, 3, 4];
        int sumEven = 0;
        for (var n in arr) {
          if (n % 2 == 0) {
            sumEven = sumEven + n;
          }
        }
        ''';
      final steps = interpreter.interpret(code, 'Dart');
      expect(steps.last.variables['sumEven'], 6);
    });

    test('parses += assignment', () {
      const code = '''
        int a = 5;
        a += 10;
        ''';

      final steps = interpreter.interpret(code, 'Dart');
      // Step 0: init (a=null or pre-init)
      // Step 1: int a = 5
      // Step 2: a += 10 -> 15
      expect(steps.last.variables['a'], 15);
    });
  });
}
