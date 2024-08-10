import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    required this.validatorType,
    required this.iconsType,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String validatorType;
  final IconData iconsType;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  // Email validation function
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    }
    // Simple regex for email validation
    final emailRegEx = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegEx.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation function
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Name validation function
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    // Add more validation logic if needed (e.g., min length, special characters, etc.)
    if (name.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  String? validateAge(String? age) {
    if (age == null || age.isEmpty) {
      return 'Age cannot be empty';
    }
    final intAge = int.tryParse(age);
    if (intAge == null) {
      return 'Please enter a valid number';
    }
    if (intAge < 18) {
      return 'You must be at least 18 years old';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          switch (widget.validatorType) {
            case "email":
              return validateEmail(value);
            case "password":
              return validatePassword(value);
            case "name":
              return validateName(value);
            case "age":
              return validateAge(value);
            default:
              return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.iconsType as IconData?,
            color: Colors.black,
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          enabled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Colors.red, width: 3),
          ),
        ),
      ),
    );
  }
}
