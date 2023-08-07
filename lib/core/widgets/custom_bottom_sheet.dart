import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'custom_button.dart';

void customShowBottomSheet({
  required BuildContext context,
  required VoidCallback onTapButton,
  required List<Widget> children,
  String buttonTitle = 'Apply',
}) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children +
              [
                CustomButton(
                  margin: const EdgeInsets.all(12),
                  height: 45,
                  onTap: onTapButton,
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
