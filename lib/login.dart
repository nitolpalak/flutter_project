import 'package:chaka_app/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String hintPhoneNumber = '+8801XXXXXXXXX';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintPhoneNumber = '1XXXXXXXXX';
      } else {
        hintPhoneNumber = '+8801XXXXXXXXX';
      }
      setState(() {});
    });
  }
  void _sendPhoneNumber(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OTPPage(phone: _phoneController.text))
    );
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
                const SizedBox(height: 140,),
                const Text(
                  'Enter Your Number',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40,),
                TextField(
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    border: const OutlineInputBorder(),
                    labelStyle: const TextStyle(fontSize: 20),
                    hintText: hintPhoneNumber,
                    prefix: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('+880'),
                    ),
                    filled: true,
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                ),
                const SizedBox(height: 60,),
                ElevatedButton(
                  onPressed: (){_sendPhoneNumber(context);},
                  child: const Text(
                    'Send OTP',
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Colors.black87),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
