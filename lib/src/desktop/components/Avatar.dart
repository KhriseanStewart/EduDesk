import 'package:flutter/material.dart';

/// Shows a circular avatar. Uses [imageUrl] when non-empty; otherwise shows
/// [name] initial or a default person icon.
class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const Avatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? const Color(0xFF4DA3B6).withOpacity(0.2);
    final fg = foregroundColor ?? const Color(0xFF4DA3B6);
    final hasUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (!hasUrl) {
      final initial = name != null && name!.trim().isNotEmpty ? name!.trim()[0].toUpperCase() : null;
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        child: initial != null
            ? Text(
                initial,
                style: TextStyle(
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
              )
            : Icon(Icons.person, size: size * 0.55, color: fg),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bg,
      child: ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.person,
            size: size * 0.55,
            color: fg,
          ),
        ),
      ),
    );
  }
}
