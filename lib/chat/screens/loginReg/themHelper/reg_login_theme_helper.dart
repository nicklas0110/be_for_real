
import 'package:flutter/material.dart';


class ThemeHelper{
  BoxDecoration inputBoxDecorationShadow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.orange.withOpacity(0.0),
        offset: const Offset(0, 1),
      )
    ]);
  }

  BoxDecoration buttonRegisterDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(8.0),
    );
  }


  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),

      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }
}

