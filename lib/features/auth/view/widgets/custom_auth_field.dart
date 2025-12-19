import 'package:flutter/material.dart';

/** customizable form field with a label 
 * and a TextFormField for user input. */
class CustomAuthField extends StatelessWidget {
  const CustomAuthField({
    super.key,//widget identification and optimizing the widget tree when the widget is rebuilt.
    this.maxLines,//number of lines the TextFormField can have,(int)
    this.inputType,//allows you to set the keyboard type(TextInputType)
    required this.text,//required parameter that sets the text for the label above the TextFormField.(string)
    this.controller,//allows you to control the text in the input field programmatically(TextEditingController)

  });

  final int? maxLines;
  final TextInputType? inputType;
  final String text;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(// *label above the TextFormField
          text,//will be paseed by user

     
          style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w900,//bold font
              height: 1.5625),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,// prevents the first line's from affecting the height calculation. 
          ),
          textAlign: TextAlign.center,//show text in center
        ),
        const SizedBox(height: 8),

        //*actual input field where the user can type

        TextFormField(
          keyboardType: inputType,// Sets the keyboard type based on the passed inputType
          controller: controller,//optional controller is used to manipulate or retrieve the value of the text in the field.
          decoration: InputDecoration(//some decoretions
            filled: true,
            //color of text field
            fillColor: Colors.grey[200],
            //Colors.transparent,
            //border and enabledBorder are properties of the InputDecoration
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[200] ?? Colors.grey),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[200] ?? Colors.grey),
            ),
          ),
        ),
      ], //children
    ); //column
  }//widget


//class custom

}//class

