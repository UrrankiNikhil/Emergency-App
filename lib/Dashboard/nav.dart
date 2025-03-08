// ignore_for_file: unused_import, deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

//main nav class
class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 8),
            spreadRadius: 5,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => 
              Expanded(
                child: Hero(
                  tag: 'navItem$index',
                  child: Material(
                    color: Colors.transparent,
                    child: _buildNavItem(index),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
//bottom navition with an good animation
  Widget _buildNavItem(int index) {
    final isSelected = selectedIndex == index;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isSelected ? 1 : 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () => onItemSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.transparent,
                const Color(0xFF1565C0).withOpacity(0.20),
                value,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.lerp(
                  Colors.transparent,
                  const Color(0xFF1565C0).withOpacity(0.4),
                  value,
                )!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.1 * value),
                  blurRadius: 10 * value,
                  offset: Offset(0, 4 * value),
                ),
              ],
            ),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: isSelected ? 1.2 : 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color.lerp(
                            Colors.grey.shade400,
                            const Color(0xFF1565C0),
                            value,
                          )!,
                          Color.lerp(
                            Colors.grey.shade400,
                            const Color(0xFF1565C0),
                            value,
                          )!,
                        ],
                      ).createShader(bounds),
                      child: Icon(
                        _getIconData(index),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
// icons data for better routes
  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.notifications_rounded;
      case 2:
        return Icons.contacts_rounded;
      case 3:
        return Icons.person_rounded;
      default:
        return Icons.home_rounded;
    }
  }
}