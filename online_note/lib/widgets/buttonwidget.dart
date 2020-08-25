import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final Function onTapFunction;
  final bool isLoading;

  ButtonWidget({this.title, this.hasBorder = false, this.onTapFunction, this.isLoading=false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: hasBorder ? Colors.transparent : const Color(0xff6aa0e1),
          border: hasBorder
              ? Border.all(color: const Color(0xff6aa0e1), width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTapFunction,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: 55.0, child: Center(child: loadingState(isLoading))),
        ),
      ),
    );
  }

  Widget loadingState(bool state) {
    if (state) {
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    } else {
      return Text(
        title,
        style: TextStyle(
            color: hasBorder ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16.0),
      );
    }
  }
}
