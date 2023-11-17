import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  final String text;
  const Button(
      {super.key,
      required this.imagePath,
      required this.onTap,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[200],
        ),
        child: SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 40,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
