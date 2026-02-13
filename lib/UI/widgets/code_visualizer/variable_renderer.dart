import 'package:flutter/material.dart';
import '../../../../model/node.dart';
import 'array_widget.dart';
import 'linked_list_widget.dart';

class VariableRenderer extends StatelessWidget {
  final String name;
  final dynamic value;

  const VariableRenderer({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value is List) {
      return ArrayWidget(name: name, data: value);
    } else if (value is Node) {
      return LinkedListWidget(name: name, head: value);
    } else {
      return _buildSimpleVariable();
    }
  }

  Widget _buildSimpleVariable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_right_alt, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Text(
              value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
