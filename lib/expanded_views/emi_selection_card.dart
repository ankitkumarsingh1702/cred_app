import 'package:flutter/material.dart';
import '../models/stack_item.dart';

class EmiSelectionCard extends StatefulWidget {
  final Body body;
  final String ctaText;
  final Function(Map<String, dynamic> data) onCtaPressed;

  EmiSelectionCard({
    required this.body,
    required this.ctaText,
    required this.onCtaPressed,
  });

  @override
  _EmiSelectionCardState createState() => _EmiSelectionCardState();
}

class _EmiSelectionCardState extends State<EmiSelectionCard> {
  String? _selectedEmi;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900], // Dark background
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
          // EMI Options (Horizontally Scrollable)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.body.items!.map((item) {
                bool isSelected = _selectedEmi == item.emi;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmi = item.emi;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.all(16),
                    width: 150, // Card width for horizontal scroll
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[700] : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: item.tag == 'recommended'
                          ? Border.all(color: Colors.green, width: 2)
                          : null,
                    ),
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
                        SizedBox(height: 8),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontFamily: 'Figtree-Regular',
                          ),
                        ),
                        if (item.tag != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.tag!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Figtree-Regular',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          // Footer Information
          Text(
            widget.body.footer!,
            style: TextStyle(
              color: Color(0xFF8E8E93), // Light gray
              fontSize: 12,
              fontFamily: 'Figtree-Regular',
            ),
          ),
          SizedBox(height: 20),
          // CTA Button
          ElevatedButton(
            onPressed: _selectedEmi != null
                ? () {
              widget.onCtaPressed({
                'emiPlan': _selectedEmi!,
                'duration': _getDuration(_selectedEmi!),
              });
            }
                : null,
            child: Text(widget.ctaText), // Updated to use widget.ctaText
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

  String _getDuration(String emi) {
    final matchedItem = widget.body.items!.firstWhere(
            (item) => item.emi == emi,
        orElse: () => Item(
            emi: emi,
            duration: '',
            title: '',
            subtitle: '',
            tag: null,
            icon: null));
    return matchedItem.duration ?? '';
  }
}
