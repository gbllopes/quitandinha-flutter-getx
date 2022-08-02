import 'package:flutter/material.dart';

import '../../config/custom_colors.dart';

class QuantityWidget extends StatefulWidget {
  int quantity;
  String unit;
  Function(int quantity) result;
  bool isRemovable;

  QuantityWidget({
    Key? key,
    this.quantity = 1,
    required this.unit,
    required this.result,
    this.isRemovable = false,
  }) : super(key: key);

  @override
  State<QuantityWidget> createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 2,
            )
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: !widget.isRemovable || widget.quantity > 1
                ? Icons.remove
                : Icons.delete_forever,
            color: !widget.isRemovable || widget.quantity > 1
                ? Colors.grey
                : Colors.red,
            onPressed: () {
              setState(() {
                if (widget.quantity > 1 || widget.isRemovable) {
                  widget.quantity--;
                  widget.result(widget.quantity);
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text('${widget.quantity}kg',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          _QuantityButton(
            icon: Icons.add,
            color: CustomColors.customSwatchColor,
            onPressed: () {
              setState(() {
                widget.quantity++;
                widget.result(widget.quantity);
              });
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
            shape: BoxShape.circle,
            color: color,
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
