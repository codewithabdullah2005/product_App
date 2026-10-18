
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/models/user_model.dart';
import 'package:product_app/theme/app_colors.dart';

import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();

  bool isLogin = true;
  bool isLoading = false;
  bool emailTouched = false;
  bool emailSubmitted = false;

  bool isNameHovered = false;
  bool isEmailHovered = false;
  bool isPasswordHovered = false;

  String? emailError;

  @override
  void initState() {
    super.initState();

    emailFocusNode.addListener(() {
      if (!mounted) return;

      if (!emailFocusNode.hasFocus) {
        setState(() {
          emailTouched = true;

          if (emailController.text.trim().isEmpty &&
              !emailSubmitted) {
            emailError = null;
          } else {
            emailError = validateEmail(emailController.text);
          }
        });
      }
    });
  }

  // THEME KA DEFAULT BORDER COLOR
  Color getDefaultBorderColor(BuildContext context) {
    final themeBorder =
        Theme.of(context).inputDecorationTheme.enabledBorder;

    if (themeBorder is OutlineInputBorder) {
      return themeBorder.borderSide.color;
    }

    return Colors.grey;
  }

  // EMAIL VALIDATION

  String? validateEmail(String email) {
    email = email.trim();

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9]+(?:[A-Za-z0-9._%+-]*[A-Za-z0-9])?@[A-Za-z0-9](?:[A-Za-z0-9.-]*[A-Za-z0-9])?\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email, please enter a valid email';
    }

    return null;
  }


  // EMAIL TYPE KARTE WAQT VALIDATION
  void onEmailChanged(String value) {
    if (emailTouched || emailSubmitted) {
      setState(() {
        emailError = validateEmail(value);
      });
    }
  }

  // LOGIN / SIGNUP
  Future<void> authenticate() async {
    setState(() {
      emailSubmitted = true;
      emailTouched = true;
      emailError = validateEmail(emailController.text);
    });

    if (emailError != null) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      if (isLogin) {
        // LOGIN
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        // SIGN UP
        final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final user = userCredential.user!;

        final userModel = UserModel(
          uid: user.uid,
          name: nameController.text.trim(),
          email: user.email ?? emailController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-credential') {
        message = 'Email or password is incorrect';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = getDefaultBorderColor(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: Center(
          child: Text(
            isLogin ? 'Login' : 'Sign Up',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Center(
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HEADING
                    Text(
                      isLogin ? 'Welcome Back' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isLogin
                          ? 'Login to continue'
                          : 'Sign up to get started',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGreen,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // NAME FIELD
                    if (!isLogin) ...[
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            isNameHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            isNameHovered = false;
                          });
                        },
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isNameHovered
                                    ? AppColors.darkGreen
                                    : defaultBorderColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.darkGreen,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],

                    // EMAIL FIELD
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isEmailHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isEmailHovered = false;
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: onEmailChanged,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                              FloatingLabelBehavior.auto,
                              labelText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              // NORMAL / HOVER BORDER
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: emailError != null
                                      ? Colors.red
                                      : isEmailHovered
                                      ? AppColors.darkGreen
                                      : defaultBorderColor,
                                ),
                              ),

                              // CLICK / FOCUS BORDER
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: emailError != null
                                      ? Colors.red
                                      : AppColors.darkGreen,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          // ERROR MESSAGE AT TOP-RIGHT

                          if (emailError != null)
                            Positioned(
                              right: 12,
                              top: -9,
                              child: IgnorePointer(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    emailError!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      backgroundColor:AppColors.lightGreen
                                    ),
                                  ),
                                ),
                              ),
                            ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // PASSWORD FIELD
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isPasswordHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isPasswordHovered = false;
                        });
                      },
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isPasswordHovered
                                  ? AppColors.darkGreen
                                  : defaultBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.darkGreen,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // LOGIN / SIGN UP BUTTON
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authenticate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // SWITCH LOGIN / SIGNUP
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                          emailTouched = false;
                          emailSubmitted = false;
                          emailError = null;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign Up"
                            : 'Already have an account? Login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
