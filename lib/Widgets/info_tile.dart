import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const InfoTile({
    Key? key,
    required this.label,
    required this.value,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 60,
      decoration: BoxDecoration(
        // color: Colors.black,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.grey.shade600,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
