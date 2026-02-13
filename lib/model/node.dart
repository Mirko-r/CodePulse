class Node {
  int value;
  Node? next;
  // Optional: ID for tracking distinct objects in visualization
  final String id;

  Node(this.value)
    : id = '${DateTime.now().microsecondsSinceEpoch}_${1000 + (value % 1000)}';

  @override
  String toString() => 'Node($value)';

  Map<String, dynamic> toJson() => {'id': id, 'value': value, 'next': next?.id};

  Node clone() {
    return Node(value)
      ..next = next; // Shallow clone of next reference, deep clone of value
    // Note: SimpleInterpreter handles the "deep" copy of the graph structure by re-mapping per step.
  }
}
