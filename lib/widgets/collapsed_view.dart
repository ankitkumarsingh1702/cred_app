import 'package:flutter/material.dart';
import '../models/stack_item.dart';

class CollapsedView extends StatelessWidget {
  final StackItem item;
  final Map<String, dynamic>? userInput;
  final VoidCallback onExpand;
  final int index;

  CollapsedView({
    required this.item,
    this.userInput,
    required this.onExpand,
    required this.index,
  });

  String _buildSummary() {
    if (userInput == null || userInput!.isEmpty) {
      if (item.closedState.body.isNotEmpty) {
        return item.closedState.body.entries
            .map((e) => '${_formatKey(e.key)}: ${_formatValue(e.value)}')
            .join(', ');
      }
      return '';
    }

    if (index == 0) {
      final creditAmount = userInput!['creditAmount'] ?? 0;
      return 'Credit Amount: ₹${_formatNumber(creditAmount)}';
    } else if (index == 1) {
      final emi = userInput!['emiPlan'] ?? '';
      final duration = userInput!['duration'] ?? '';
      return 'EMI Plan: $emi for $duration';
    } else if (index == 2) {
      final bank = userInput!['bankAccount'] ?? '';
      return 'Bank: $bank';
    }

    return '';
  }

  String _formatNumber(dynamic number) {
    if (number is int || number is double) {
      String numStr = number.toInt().toString();
      RegExp reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
      return numStr.replaceAllMapped(reg, (Match match) => '${match[1]},');
    }
    return number.toString();
  }

  String _formatKey(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }

  String _formatValue(dynamic value) {
    if (value is int || value is double) {
      return '₹${_formatNumber(value)}';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    String summary = _buildSummary();

    return GestureDetector(
      onTap: onExpand,
      child: Container(
        height: 90,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.5), // Half transparent color
              // Colors.grey[800]!,             // Solid color
            Colors.transparent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 40,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                summary,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
