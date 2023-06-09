import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/user.dart';

class UidButton extends StatelessWidget {
  const UidButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user.email ?? user.uid),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: qrImageView(
                    data: user.uid,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              )
            ],
          ),
        );
      },
      icon: const Icon(Icons.person_pin),
    );
  }
}

qrImageView({required String data, required int version, required int size}) {
}