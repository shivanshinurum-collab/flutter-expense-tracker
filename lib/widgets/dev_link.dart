import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DevLink extends StatelessWidget {
  final VoidCallback onPressed;
  final dynamic icon;
  final String label;

  const DevLink({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(
            Size(MediaQuery.of(context).size.width * 0.75, 50.0),
          ),
          elevation: WidgetStateProperty.all<double>(4.0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(16.0),
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
          backgroundColor:
              WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}


