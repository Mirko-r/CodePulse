import '../model/visualizer_state.dart';
import '../model/node.dart';

class SimpleInterpreter {
  List<VisualizerState> interpret(String code, String language) {
    if (code.trim().isEmpty) return [];

    List<VisualizerState> steps = [];
    Map<String, dynamic> variables = {};
    List<String> output = [];

    // Capture all lines to reference original indices
    List<String> allLines = code.split('\n');

    // Initial state
    steps.add(
      VisualizerState(
        running: true,
        paused: false,
        currentStep: 0,
        currentLine: 0,
        variables: Map.from(variables),
        output: List.from(output),
      ),
    );

    // Execute the global block (all lines)
    _executeBlock(
      0,
      allLines.length,
      allLines,
      variables,
      output,
      steps,
      language,
    );

    return steps;
  }

  /// Executes lines from [startLine] (inclusive) to [endLine] (exclusive)
  void _executeBlock(
    int startLine,
    int endLine,
    List<String> allLines,
    Map<String, dynamic> variables,
    List<String> output,
    List<VisualizerState> steps,
    String language,
  ) {
    for (int i = startLine; i < endLine; i++) {
      String line = allLines[i].trim();
      if (line.isEmpty || line.startsWith('//') || line.startsWith('#')) {
        continue;
      }

      // --- LOOP (FOR-IN) ---
      if (line.startsWith('for (')) {
        final forInMatch = RegExp(
          r'for\s*\(\s*(?:var|int)\s+(\w+)\s+in\s+(\w+)\s*\)',
        ).firstMatch(line);
        if (forInMatch != null) {
          String loopVar = forInMatch.group(1)!;
          String listName = forInMatch.group(2)!;

          int endLoopLine = _findBlockEnd(i, allLines);
          if (endLoopLine != -1) {
            if (variables.containsKey(listName) &&
                variables[listName] is List) {
              List list = variables[listName];
              int iterations = 0;
              for (var item in list) {
                if (iterations > 100) break;
                variables[loopVar] = item;
                _addStep(i, variables, output, steps);
                _executeBlock(
                  i + 1,
                  endLoopLine,
                  allLines,
                  variables,
                  output,
                  steps,
                  language,
                );
                iterations++;
              }
            }
            i = endLoopLine;
            continue;
          }
        }
      }

      // --- LOOP (C-STYLE) ---
      if (language == 'Dart' && line.startsWith('for (')) {
        final match = RegExp(
          r'for\s*\(\s*int\s+(\w+)\s*=\s*(.+?)\s*;\s*\1\s*(<|>|<=|>=|!=|==)\s*(.+?)\s*;\s*\1(\+\+|\-\-)\s*\)',
        ).firstMatch(line);

        if (match != null) {
          String varName = match.group(1)!;
          String startExp = match.group(2)!;
          String op = match.group(3)!;
          String endExp = match.group(4)!;

          int start = _parseMathExpression(startExp, variables);
          int end = _parseMathExpression(endExp, variables);
          int endLoopLine = _findBlockEnd(i, allLines);

          if (endLoopLine != -1) {
            int iterations = 0;
            for (
              int val = start;
              _checkCondition(val, op, end) && iterations < 100;
              val += (match.group(5) == '++' ? 1 : -1), iterations++
            ) {
              variables[varName] = val;
              _addStep(i, variables, output, steps);
              _executeBlock(
                i + 1,
                endLoopLine,
                allLines,
                variables,
                output,
                steps,
                language,
              );
              end = _parseMathExpression(endExp, variables);
            }
            i = endLoopLine;
            continue;
          }
        }
      }

      // --- LOOP (WHILE) ---
      if (line.startsWith('while (')) {
        final match = RegExp(r'while\s*\((.+?)\)(?:\s*\{)?').firstMatch(line);
        if (match != null) {
          String condition = match.group(1)!;
          int endLoopLine = _findBlockEnd(i, allLines);

          if (endLoopLine != -1) {
            int iterations = 0;
            while (_evaluateCondition(condition, variables) &&
                iterations < 100) {
              _addStep(i, variables, output, steps);
              _executeBlock(
                i + 1,
                endLoopLine,
                allLines,
                variables,
                output,
                steps,
                language,
              );
              iterations++;
            }
            i = endLoopLine;
            continue;
          }
        }
      }

      // --- IF (With or Without Blocks) ---
      if (line.startsWith('if (')) {
        final match = RegExp(r'if\s*\((.+?)\)(?:\s*\{)?(.*)$').firstMatch(line);
        if (match != null) {
          String condition = match.group(1)!;
          String restOfLine = match.group(2)!.trim();
          bool result = _evaluateCondition(condition, variables);

          // Always add step for the IF line
          _addStep(i, variables, output, steps);

          if (line.contains('{')) {
            // Block IF
            int endIfLine = _findBlockEnd(i, allLines);
            if (endIfLine != -1) {
              if (result) {
                _executeBlock(
                  i + 1,
                  endIfLine,
                  allLines,
                  variables,
                  output,
                  steps,
                  language,
                );
              }
              i = endIfLine;
              continue;
            }
          } else {
            // Brace-less IF (single statement on same line or next line)
            if (result) {
              if (restOfLine.isNotEmpty) {
                _executeSingleStatement(
                  i,
                  restOfLine,
                  variables,
                  output,
                  steps,
                );
              } else if (i + 1 < allLines.length) {
                // Execute next line as the IF body
                String nextLine = allLines[i + 1].trim();
                _executeSingleStatement(
                  i + 1,
                  nextLine,
                  variables,
                  output,
                  steps,
                );
                i++; // Skip next line as it's been executed
              }
            } else if (restOfLine.isEmpty) {
              // Condition false, skip next line
              i++;
            }
            continue;
          }
        }
      }

      // --- Regular Statement ---
      _executeSingleStatement(i, line, variables, output, steps);
    }
  }

  /// Executes a single line statement (assignment, print, etc.)
  void _executeSingleStatement(
    int lineIndex,
    String line,
    Map<String, dynamic> variables,
    List<String> output,
    List<VisualizerState> steps,
  ) {
    String cleanLine = line.trim().replaceAll(';', '');
    if (cleanLine.isEmpty ||
        cleanLine.startsWith('//') ||
        cleanLine.startsWith('#') ||
        cleanLine == '}') {
      return;
    }

    // Assignment
    final assignMatch = RegExp(
      r'^(?:(?:int|String|var|List<int>|double|Node)\s+)?(\w+)\s*([+\-*/]?=)\s*(.+)$',
    ).firstMatch(cleanLine);

    if (assignMatch != null) {
      String name = assignMatch.group(1)!;
      String op = assignMatch.group(2)!;
      String rawValue = assignMatch.group(3)!;

      if (!name.contains('.')) {
        dynamic rightValue = _parseValue(rawValue, variables);
        dynamic leftValue = variables[name];

        if (op == '=') {
          variables[name] = rightValue;
        } else if (leftValue is num && rightValue is num) {
          switch (op) {
            case '+=':
              variables[name] = leftValue + rightValue;
              break;
            case '-=':
              variables[name] = leftValue - rightValue;
              break;
            case '*=':
              variables[name] = leftValue * rightValue;
              break;
            case '/=':
              variables[name] = leftValue / rightValue;
              break;
          }
        }
        _addStep(lineIndex, variables, output, steps);
        return;
      }
    }

    // Standalone increment/decrement
    final incDecMatch = RegExp(r'^(\w+)(\+\+|\-\-)$').firstMatch(cleanLine);
    if (incDecMatch != null) {
      String name = incDecMatch.group(1)!;
      String op = incDecMatch.group(2)!;
      if (variables.containsKey(name) && variables[name] is num) {
        if (op == '++') {
          variables[name]++;
        } else {
          variables[name]--;
        }
        _addStep(lineIndex, variables, output, steps);
      }
      return;
    }

    // Array Set
    final listSetMatch = RegExp(
      r'^(\w+)\[(.+)\]\s*=\s*(.+)$',
    ).firstMatch(cleanLine);
    if (listSetMatch != null) {
      String listName = listSetMatch.group(1)!;
      String indexExp = listSetMatch.group(2)!;
      String valExp = listSetMatch.group(3)!;

      if (variables.containsKey(listName) && variables[listName] is List) {
        int index = _parseMathExpression(indexExp, variables);
        dynamic val = _parseValue(valExp, variables);
        List list = variables[listName];

        if (index >= 0 && index < list.length) {
          list[index] = val;
          _addStep(lineIndex, variables, output, steps);
        }
      }
      return;
    }

    // Node Set
    final nodeSetMatch = RegExp(
      r'^(\w+)\.(next|value)\s*=\s*(.+)$',
    ).firstMatch(cleanLine);
    if (nodeSetMatch != null) {
      String nodeName = nodeSetMatch.group(1)!;
      String prop = nodeSetMatch.group(2)!;
      String valExp = nodeSetMatch.group(3)!;
      if (variables.containsKey(nodeName) && variables[nodeName] is Node) {
        Node node = variables[nodeName];
        dynamic val = _parseValue(valExp, variables);
        if (prop == 'next' && (val is Node || val == null)) node.next = val;
        if (prop == 'value' && val is int) node.value = val;
        _addStep(lineIndex, variables, output, steps);
      }
      return;
    }

    // Print
    if (cleanLine.startsWith('print(')) {
      String content = cleanLine.substring(6, cleanLine.length - 1);
      if (content.startsWith("'") && content.endsWith("'")) {
        String inner = content.substring(1, content.length - 1);
        inner = inner.replaceAllMapped(
          RegExp(r'\$\{?([a-zA-Z0-9_\+\-\s\[\]]+)\}?'),
          (match) {
            String exp = match.group(1)!;
            dynamic val = _parseValue(exp, variables);
            return val.toString();
          },
        );
        output.add(inner);
      } else {
        output.add(_parseValue(content, variables).toString());
      }
      _addStep(lineIndex, variables, output, steps);
      return;
    }
  }

  void _addStep(
    int lineIndex,
    Map<String, dynamic> vars,
    List<String> out,
    List<VisualizerState> steps,
  ) {
    steps.add(
      VisualizerState(
        running: true,
        paused: false,
        currentStep: steps.length,
        currentLine: lineIndex,
        variables: _deepCopyVariables(vars),
        output: List.from(out),
      ),
    );
  }

  int _findBlockEnd(int startLine, List<String> lines) {
    int braceCount = 0;
    bool foundStart = false;
    for (int j = startLine; j < lines.length; j++) {
      if (lines[j].contains('{')) {
        braceCount++;
        foundStart = true;
      }
      if (lines[j].contains('}')) {
        braceCount--;
        if (foundStart && braceCount == 0) return j;
      }
    }
    return -1;
  }

  // ... [keep deepCopyVariables as is] ...
  Map<String, dynamic> _deepCopyVariables(Map<String, dynamic> vars) {
    Map<String, dynamic> copy = {};
    Map<Node, Node> nodeMap = {};
    vars.forEach((key, value) {
      if (value is Node) {
        if (!nodeMap.containsKey(value)) {
          nodeMap[value] = value.clone();
        }
      }
    });
    vars.forEach((key, value) {
      if (value is Node) {
        copy[key] = nodeMap[value];
        if (value.next != null && nodeMap.containsKey(value.next)) {
          copy[key].next = nodeMap[value.next];
        } else if (value.next != null) {
          copy[key].next = value.next;
        }
      } else if (value is List) {
        copy[key] = List.from(value);
      } else {
        copy[key] = value;
      }
    });
    return copy;
  }

  int _parseMathExpression(String exp, Map<String, dynamic> vars) {
    exp = exp.trim();
    // Improved tokenization to handle spaces between operators
    List<String> terms = exp.split(
      RegExp(r'\s+(?=[+\-%])|(?<=[+\-%])\s+|(?=[+\-%])|(?<=[+\-%])'),
    );
    int result = 0;
    String currentOp = '+';

    // First pass: handle multiplication/division/modulo (simplified to just modulo for now per request)
    // Actually, simple sequential evaluation is safer for this limited interpreter
    // But we need to handle "n % 2" correctly.

    // If expression is just one term, parse it
    if (terms.length == 1) return _parseInt(terms[0], vars);

    // Simple left-to-right evaluation
    for (int i = 0; i < terms.length; i++) {
      String term = terms[i].trim();
      if (term.isEmpty) continue;

      if (term == '+' || term == '-' || term == '%') {
        currentOp = term;
      } else {
        int val = _parseInt(term, vars);
        if (i == 0) {
          result = val;
        } else {
          if (currentOp == '+') result += val;
          if (currentOp == '-') result -= val;
          if (currentOp == '%') result %= val;
        }
      }
    }
    return result;
  }

  bool _checkCondition(int val, String op, int end) {
    switch (op) {
      case '<':
        return val < end;
      case '>':
        return val > end;
      case '<=':
        return val <= end;
      case '>=':
        return val >= end;
      case '==':
        return val == end;
      case '!=':
        return val != end;
      default:
        return false;
    }
  }

  int _parseInt(String exp, Map<String, dynamic> vars) {
    exp = exp.trim();
    try {
      return int.parse(exp);
    } catch (e) {
      dynamic val = _resolveValue(exp, vars);
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
    }
    return 0;
  }

  bool _evaluateCondition(String condition, Map<String, dynamic> vars) {
    condition = condition.trim();

    // Handle logical AND (&&) with short-circuiting
    if (condition.contains('&&')) {
      int idx = condition.indexOf('&&');
      String leftPart = condition.substring(0, idx);
      String rightPart = condition.substring(idx + 2);
      return _evaluateCondition(leftPart, vars) &&
          _evaluateCondition(rightPart, vars);
    }

    // Handle logical OR (||) with short-circuiting
    if (condition.contains('||')) {
      int idx = condition.indexOf('||');
      String leftPart = condition.substring(0, idx);
      String rightPart = condition.substring(idx + 2);
      return _evaluateCondition(leftPart, vars) ||
          _evaluateCondition(rightPart, vars);
    }

    final match = RegExp(
      r'(.+?)\s*(>=|<=|>|<|==|!=)\s*(.+)$',
    ).firstMatch(condition);
    if (match != null) {
      dynamic left = _resolveValue(match.group(1)!, vars);
      dynamic right = _resolveValue(match.group(3)!, vars);
      String op = match.group(2)!;

      if (left is num && right is num) {
        switch (op) {
          case '>':
            return left > right;
          case '<':
            return left < right;
          case '>=':
            return left >= right;
          case '<=':
            return left <= right;
          case '==':
            return left == right;
          case '!=':
            return left != right;
        }
      }
    }

    // Handle boolean literals or variables
    dynamic val = _resolveValue(condition, vars);
    if (val is bool) return val;

    return false;
  }

  dynamic _parseValue(String raw, Map<String, dynamic> vars) {
    return _resolveValue(raw, vars);
  }

  dynamic _resolveValue(String exp, Map<String, dynamic> vars) {
    exp = exp.trim();
    if (exp.isEmpty) return null;

    // Number
    if (RegExp(r'^-?\d+$').hasMatch(exp)) return int.parse(exp);

    // String
    if ((exp.startsWith('"') && exp.endsWith('"')) ||
        (exp.startsWith("'") && exp.endsWith("'"))) {
      return exp.substring(1, exp.length - 1);
    }

    // List Literal
    if (exp.startsWith('[') && exp.endsWith(']')) {
      String content = exp.substring(1, exp.length - 1);
      if (content.trim().isEmpty) return [];
      return content.split(',').map((e) => _resolveValue(e, vars)).toList();
    }

    // Array Access: arr[index] - more permissive regex
    final arrayMatch = RegExp(r'^(\w+)\s*\[(.+)\]$').firstMatch(exp);
    if (arrayMatch != null) {
      String name = arrayMatch.group(1)!;
      String indexExp = arrayMatch.group(2)!;
      if (vars.containsKey(name) && vars[name] is List) {
        int index = _parseMathExpression(indexExp, vars);
        List list = vars[name];
        if (index >= 0 && index < list.length) return list[index];
      }
      return null;
    }

    // Property: obj.prop
    if (exp.contains('.') && !RegExp(r'^\d+\.\d+$').hasMatch(exp)) {
      var parts = exp.split('.');
      String name = parts[0];
      String prop = parts[1];
      if (vars.containsKey(name)) {
        var obj = vars[name];
        if (obj is List && prop == 'length') return obj.length;
        if (obj is Node) {
          if (prop == 'value') return obj.value;
          if (prop == 'next') return obj.next;
        }
      }
    }

    // Math Expression (n + 1, etc.)
    if (exp.contains('+') || exp.contains('-') || exp.contains('%')) {
      return _parseMathExpression(exp, vars);
    }

    // Variable
    if (vars.containsKey(exp)) return vars[exp];

    return exp;
  }
}
