import 'package:flutter/material.dart';
import '../../app/theme.dart';

class PremiumBadge extends StatelessWidget {
  final bool small;
  const PremiumBadge({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.premium,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded,
              color: Colors.black, size: small ? 12 : 14),
          SizedBox(width: small ? 3 : 4),
          Text('Pro',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: small ? 10 : 11,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
