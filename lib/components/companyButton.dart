import 'package:flutter/material.dart';

class CompanyButton extends StatelessWidget {
  String name;
  BoxConstraints constraints;
  void Function() onTap;
  Color? buttonColor;

  CompanyButton({
    super.key,
    required this.name,
    required this.constraints,
    required this.onTap,
    this.buttonColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          width: constraints.maxWidth * .9,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: buttonColor,
          ),
          child: Center(
            child: Row(
              children: [
                const SizedBox(width: 20),
                const Icon(
                  Icons.scatter_plot,
                  size: 35,
                  color: Colors.white,
                ),
                const SizedBox(width: 20),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
