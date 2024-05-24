import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  String buttonText;
  double height;
  double width;
  double borderRadius;
  void Function() onTap;
  IconData icon;
  double? iconSize;
  Color? iconColor;
  Color? buttonColor;
  Color? textColor;
  bool? isTrailing;
  bool? hasBorder;
  Color? borderColor;

  ButtonWithIcon({
    super.key,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.onTap,
    required this.icon,
    this.buttonColor,
    this.iconColor,
    this.iconSize,
    this.textColor,
    this.isTrailing = false,
    this.hasBorder = false,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          border: hasBorder!
              ? Border.all(
                  color: Colors.transparent,
                )
              : Border.all(
                  color: borderColor!,
                  width: .7,
                ),
          color: buttonColor ?? Colors.blue.withOpacity(.5),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isTrailing!
                  ? const Center()
                  : Icon(
                      icon,
                      size: iconSize ?? 16,
                      color: iconColor ?? Colors.blue,
                    ),
              isTrailing! ? const Center() : const SizedBox(width: 10),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              isTrailing! ? const SizedBox(width: 10) : const Center(),
              isTrailing!
                  ? Icon(
                      icon,
                      size: iconSize ?? 16,
                      color: iconColor ?? Colors.blue,
                    )
                  : const Center()
            ],
          ),
        ),
      ),
    );
  }
}
