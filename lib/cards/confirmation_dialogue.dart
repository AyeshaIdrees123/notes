import 'package:flutter/material.dart';

class ConfirmationDialogue extends StatelessWidget {
  const ConfirmationDialogue({
    super.key,
    required this.title,
    this.yesButtonTitle,
    this.noButtonTitle,
    this.onPressed,
  });
  final String title;
  final String? yesButtonTitle;
  final String? noButtonTitle;
  final void Function(bool)? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 236,
      width: 330,
      child: AlertDialog(
        backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const SizedBox(height: 30),
              const Icon(
                Icons.info,
                size: 30,
                color: Color.fromRGBO(96, 96, 96, 1),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 39,
                width: 112,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onPressed?.call(false);
                  },
                  child: Text(
                    noButtonTitle ?? "Discard",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                height: 39,
                width: 112,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(48, 190, 113, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onPressed?.call(true);
                  },
                  child: Text(
                    yesButtonTitle ?? 'Save',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
