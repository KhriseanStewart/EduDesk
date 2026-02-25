import 'package:flutter/material.dart';
import 'package:mac_app/src/utils/responsive.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isCompact = context.isCompact;
    final useMobileShell = context.useMobileShell;
    final padding = context.responsivePadding;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: isCompact ? 10 : 14),
      child: Row(
        children: [
          if (!useMobileShell)
            Flexible(
              child: Text(
                title,
                style: TextStyle(fontSize: isCompact ? 18 : 22, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (!useMobileShell) const Spacer(),
          if (!isCompact && !useMobileShell)
            Expanded(
              flex: 2,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search your library",
                    suffixIcon: const Icon(Icons.search, size: 20),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          if (!isCompact && !useMobileShell) SizedBox(width: padding * 0.5),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, size: isCompact ? 22 : 24),
            style: IconButton.styleFrom(backgroundColor: useMobileShell ? Colors.transparent : Colors.white),
          ),
          if (!isCompact && !useMobileShell)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
              style: IconButton.styleFrom(backgroundColor: Colors.white),
            ),
          if (useMobileShell) const Spacer(),
        ],
      ),
    );
  }
}
