import 'package:flutter/material.dart';
import '../models/stack_item.dart';

class BankAccountSelectionCard extends StatefulWidget {
  final Body body;
  final String ctaText;
  final Function(Map<String, dynamic> data) onCtaPressed;

  BankAccountSelectionCard({
    required this.body,
    required this.ctaText,
    required this.onCtaPressed,
  });

  @override
  _BankAccountSelectionCardState createState() =>
      _BankAccountSelectionCardState();
}

class _BankAccountSelectionCardState extends State<BankAccountSelectionCard> {
  String? _selectedBank;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.5),
            // Colors.grey[900]!,
          Colors.transparent
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.body.title!,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Figtree-Regular',
            ),
          ),
          SizedBox(height: 4),
          // Subtitle
          Text(
            widget.body.subtitle!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              fontFamily: 'Figtree-Regular',
            ),
          ),
          SizedBox(height: 20),
          // Bank Account Options wrapped in Expanded
          Expanded(
            child: ListView(
              children: widget.body.items!.map((item) {
                bool isSelected = _selectedBank == item.title;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBank = item.title;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[700] : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Icon Placeholder
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white, // Placeholder color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Bank Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Figtree-Regular',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Account Number: ${_formatAccountNumber(item.subtitle)}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                  fontFamily: 'Figtree-Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Selection Indicator
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Footer and Button at the bottom
          SizedBox(height: 20),
          Text(
            widget.body.footer!,
            style: TextStyle(
              color: Color(0xFF8E8E93), // Light gray
              fontSize: 12,
              fontFamily: 'Figtree-Regular',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedBank != null
                ? () {
              widget.onCtaPressed({'bankAccount': _selectedBank!});
            }
                : null,
            child: Text(widget.ctaText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // CTA button color
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Figtree-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAccountNumber(dynamic accountNumber) {
    // Format account number with spaces for readability
    String numStr = accountNumber.toString();
    RegExp reg = RegExp(r".{1,4}");
    Iterable<Match> matches = reg.allMatches(numStr);
    return matches.map((m) => m.group(0)).join(' ');
  }
}
