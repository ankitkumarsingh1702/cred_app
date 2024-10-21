import 'package:flutter/material.dart';
import '../expanded_views/bank_account_selection.dart';

import '../expanded_views/credit_selection_card.dart';
import '../expanded_views/emi_selection_card.dart';
import '../models/stack_item.dart';

class ExpandedViewWidget extends StatelessWidget {
  final StackItem item;
  final int index;
  final Function(Map<String, dynamic> data) onCtaPressed;
  final VoidCallback onBack;

  ExpandedViewWidget({
    required this.item,
    required this.index,
    required this.onCtaPressed,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return CreditSelectionCard(
          body: item.openState.body,
          ctaText: item.ctaText,
          onCtaPressed: onCtaPressed,
        );
      case 1:
        return EmiSelectionCard(
          body: item.openState.body,
          ctaText: item.ctaText,
          onCtaPressed: onCtaPressed,
        );
      case 2:
        return BankAccountSelectionCard(
          body: item.openState.body,
          ctaText: item.ctaText,
          onCtaPressed: onCtaPressed,
        );
      default:
        return SizedBox.shrink();
    }
  }
}
