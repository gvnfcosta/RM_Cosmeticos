import 'package:flutter/material.dart';
import '/src/config/custom_colors.dart';

class QuantityWidget extends StatelessWidget {
  const QuantityWidget(
      {super.key,
      required this.suffixText,
      required this.value,
      required this.result,
      this.isRemovable = false});

  final int value;
  final String suffixText;
  final Function(int quantity) result;
  final bool isRemovable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // para ajustar linha cabendo os items
        children: [
          //Botão reduz a quantidade
          _QuantityButton(
            color: !isRemovable || value > 1 ? Colors.grey : Colors.red,
            icon:
                !isRemovable || value > 1 ? Icons.remove : Icons.delete_forever,
            onPressed: () {
              if (value == 1 && !isRemovable) return;
              int resultCount = value - 1;
              result(resultCount);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$value $suffixText',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Botão aumenta quantidade
          _QuantityButton(
            color: CustomColors.customSwatchColor,
            icon: Icons.add,
            onPressed: () {
              int resultCount = value + 1;
              result(resultCount);
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Ink(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
