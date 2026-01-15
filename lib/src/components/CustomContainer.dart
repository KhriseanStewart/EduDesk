import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget? content;
  final String? headerTitle;
  final double? dataNumbers;
  final double? increasedNumbers;
  const CustomContainer({
    Key? key,
    this.content,
    required this.height,
    required this.width,
    this.headerTitle,
    this.dataNumbers,
    this.increasedNumbers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      width: width,
      height: height,
      padding: EdgeInsets.all(8),
      child:
          content ??
          Column(
            children: [
              Text(headerTitle ?? "", style: TextStyle(color: color)),
              Row(
                children: [
                  Text(
                    "${dataNumbers ?? 0}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    "${increasedNumbers ?? 0}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                color: Colors.green,
              ),
            ],
          ),
    );
  }
}
