import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const CustomTextField({
    Key? key,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _textController;
  late String error; // Define error as late String

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    error = ''; // Initialize error as an empty string
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          child: TextFormField(
            // anim
            controller: _textController,
            cursorColor: Colors.greenAccent,
            decoration: const InputDecoration(
              errorStyle: TextStyle(height: 0),
              hintText: 'Enter your text',
              border: InputBorder.none,
            ),
            validator: (value) {
              // Call the parent's validator only if the error is empty
              if (error.isEmpty) {
                final validationResult = widget.validator?.call(value);
                print(validationResult);

                // Update the error based on the validation result
                setState(() {
                  error =
                      validationResult ?? ''; // Update with your custom logic
                });
                // print(validationResult.runtimeType);

                // Return the validation result to indicate the result to the TextFormField
                return null;
              }

              // If there is already an error, return null to pass the validation
              return 'null';
            },
            // validator: widget.validator,
            onChanged: (value) {
              print(error);
              // Call the onChanged function passed from the parent widget
              widget.onChanged?.call(value);
              setState(() {
                error = ''; // Clear error when text changes
              });
            },
          ),
        ),
        // widget.validator?.call()
        // widget.validator
        error.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      error,
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
