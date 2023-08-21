import 'package:flutter/material.dart';

class GenderSelectDialog extends StatefulWidget {
  const GenderSelectDialog({
    Key? key,
    required this.getGender,
  }) : super(key: key);

  final Function? getGender;

  @override
  State<GenderSelectDialog> createState() => _GenderSelectDialogState();
}

class _GenderSelectDialogState extends State<GenderSelectDialog> {
  String selectedGender = '';

  void getGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    List<String> options = [
      'Male',
      'Female',
      'Other',
    ];

    return StatefulBuilder(
      builder: (context, newSetState) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        actions: [
          TextButton(
            onPressed: () {
              widget.getGender!('Gender', selectedGender);
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.purple[900],
              ),
            ),
          ),
        ],
        title: const Text('Choose your gender'),
        content: SizedBox(
          width: size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: options
                  .map(
                    (gender) => GenderContainer(
                      gender: gender,
                      selectedGender: selectedGender,
                      getGender: getGender,
                      newSetState: newSetState,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class GenderContainer extends StatelessWidget {
  const GenderContainer({
    Key? key,
    required this.gender,
    required this.selectedGender,
    required this.getGender,
    required this.newSetState,
  }) : super(key: key);

  final String gender;
  final String selectedGender;
  final Function getGender;
  final Function newSetState;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
      ),
      onPressed: () {
        newSetState(() {
          getGender(gender);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            gender,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Icon(
            gender == selectedGender
                ? Icons.circle_rounded
                : Icons.circle_outlined,
            color: Colors.purple[900],
          ),
        ],
      ),
    );
  }
}
