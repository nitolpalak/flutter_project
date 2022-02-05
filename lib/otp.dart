// ignore_for_file: avoid_print, prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:chaka_app/home.dart';

class OTPPage extends StatefulWidget {
  final String phone;
  const OTPPage({Key? key, required this.phone}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String _verificationCode = "";
  final int _timeOutDuration = 60;
  int _counter = 0;
  Timer? _timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextStyle defaultTextStyle =  TextStyle(
    color: Colors.black87,
  );
  final TextStyle linkStyle = TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  );
  final BoxDecoration pinPutDecoration = BoxDecoration(
    // color: const Color.fromRGBO(43, 46, 66, 1),
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      // color: const Color.fromRGBO(126, 203, 224, 1),
      color: Colors.black87,
    ),
  );

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          children: [
            Column(
              children: <Widget>[
                const SizedBox(height: 60,),
                Container(
                  constraints: const BoxConstraints.tightFor(width: 250, height: 60),
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black87,
                    ),
                  ),
                  child: const Text(
                    'Chaka',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 200,),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    withCursor: true,
                    textStyle: const TextStyle(fontSize: 25.0, color: Colors.black87),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                    onSubmit: (pin) async {
                      try{
                        await FirebaseAuth.instance.signInWithCredential(
                            PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: pin))
                            .then((value) async {
                          if(value.user != null){
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false
                            );
                          }
                        });
                      }
                      catch(e){
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid OTP'))
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                Text(
                  '${_counter}s',
                  style: defaultTextStyle,
                ),
                const SizedBox(height: 15,),
                Text(
                  "Didn't get OTP?",
                  style: defaultTextStyle,
                ),
               RichText(
                 text: TextSpan(
                   style: defaultTextStyle,
                   children: <TextSpan>[
                     TextSpan(
                       text: "Click Here",
                       style: linkStyle,
                       recognizer: TapGestureRecognizer()
                         ..onTap = (){
                         _startTimer();
                       },
                     ),
                     TextSpan(
                       text: " to get again.",
                       style: defaultTextStyle,
                     ),
                   ]
                 ),
               )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+880${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
                if(value.user != null){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false
                  );
                }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken){
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID){
          _startTimer();
          setState(() {
            _verificationCode = verificationID;
          });
        },
      timeout: Duration(seconds: _timeOutDuration),
    );
  }

  // TODO: Trigger _verifyPhone() async function from pressing 'click here'
  // TODO: Make _startTimer async or synchronized with _verifyPhone() if possible
  // TODO: Test with Firebase
  
  void _startTimer(){
    _counter = _timeOutDuration;
    if(_timer != null){
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if(_counter > 0){
          _counter --;
        }
        else{
          _timer!.cancel();
        }
      });
    });
  }
}

