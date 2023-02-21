import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/extensions.dart';
import '../constants/constants.dart';
import '../widgets/login_form.dart';
import '../widgets/sign_up_form.dart';
import '../widgets/social_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isShowSignUp = false;
  late AnimationController _animationController;
  late Animation<double> _animationTextRotate;

  @override
  void initState() {
    setUpAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void setUpAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: defaultDuration);
    _animationTextRotate = Tween<double>(begin: 0, end: 90).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  void updateView() {
    setState(() {
      _isShowSignUp = !_isShowSignUp;
    });
    _isShowSignUp
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double _width = context.width;
    double _height = context.height;

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Stack(
                children: [
                  // login screen
                  AnimatedPositioned(
                    duration: defaultDuration,
                    width: _width * 0.88,
                    height: _height,
                    left: _isShowSignUp ? -_width * 0.76 : 0,
                    child: Container(
                      color: loginBg,
                      child: const LoginForm(),
                    ),
                  ),

                  // signUp screen
                  AnimatedPositioned(
                    duration: defaultDuration,
                    left: _isShowSignUp ? _width * 0.12 : _width * 0.88,
                    width: _width * 0.88,
                    height: _height,
                    child: Container(
                      color: signUpBg,
                      child: const SignUpForm(),
                    ),
                  ),

                  // logo
                  AnimatedPositioned(
                    // left: 0,
                    duration: defaultDuration,
                    width: _width,
                    right: _isShowSignUp ? -_width * 0.06 : _width * 0.06,
                    top: context.height * 0.1, // 10%
                    child: CircleAvatar(
                      backgroundColor: Colors.white60,
                      radius: 40,
                      child: AnimatedSwitcher(
                        duration: defaultDuration,
                        child: SvgPicture.asset('assets/animation_logo.svg',
                            color: _isShowSignUp ? signUpBg : loginBg),
                      ),
                    ),
                  ),

                  // social media
                  AnimatedPositioned(
                    duration: defaultDuration,
                    // left: 0,
                    width: _width,
                    right: _isShowSignUp ? -_width * 0.06 : _width * 0.06,
                    bottom: context.height * 0.1, // 10%
                    child: const SocialButtons(),
                  ),

                  //login text animation
                  AnimatedPositioned(
                    duration: defaultDuration,
                    bottom: _isShowSignUp
                        ? context.height / 2 - 80
                        : context.height * 0.3, //30%
                    left: _isShowSignUp
                        ? 0
                        : _width * 0.44 - 80, // container width is 160 / 2 = 80
                    child: AnimatedDefaultTextStyle(
                      duration: defaultDuration,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isShowSignUp ? Colors.white : Colors.white70,
                        fontSize: _isShowSignUp ? 20 : 32,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Transform.rotate(
                        angle: -_animationTextRotate.value * pi / 180,
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            if (_isShowSignUp) {
                              updateView();
                            } else {
                              // login screen appear
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.75),
                            width: 160,
                            child: const Text(
                              'LOG IN',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //signUp text animation
                  AnimatedPositioned(
                    duration: defaultDuration,
                    bottom: !_isShowSignUp
                        ? context.height / 2 - 80
                        : context.height * 0.3, //30%
                    right: _isShowSignUp
                        ? _width * 0.44 - 80
                        : 0, // width container is 160 / 2 = 80
                    child: AnimatedDefaultTextStyle(
                      duration: defaultDuration,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isShowSignUp ? Colors.white70 : Colors.white,
                        fontSize: !_isShowSignUp ? 20 : 32,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Transform.rotate(
                        angle: (90 - _animationTextRotate.value) * pi / 180,
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            if (!_isShowSignUp) {
                              updateView();
                            } else {
                              // SignUp screen appear
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.75),
                            width: 160,
                            child: const Text(
                              'SIGN UP',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
