import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintAuth extends StatefulWidget {
  const FingerPrintAuth({Key? key}) : super(key: key);

  @override
  _FingerprintAuthState createState() => _FingerprintAuthState();
}

class _FingerprintAuthState extends State<FingerPrintAuth> {
  final auth = LocalAuthentication();
  String authorized = "not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  Future<void> _authenticate() async{
    bool authehticated = false;

    try{
      authehticated = await auth.authenticate(
        localizedReason: "Scan your finger to authenticate",
        options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: false
        ),
      );
    } on PlatformException catch(e){
      print(e);
    }

    setState(() {
      authorized = authehticated? "Successfully authorized":"Failed to authenticate";
    print(authorized);
    });
  }

  Future<void> _checkBiometric() async{
    bool canCheckBiometric = false;

    try{
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e){
      print(e);
    }

    if(!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });

  }

  Future _getAvailableBiometric() async{
    List<BiometricType> availableBiometric = [];

    try{
      availableBiometric = await auth.getAvailableBiometrics();

    } on PlatformException catch (e){
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });

  }

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("FingerPrint auth")),
      backgroundColor: Color(0xff323236),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Login", style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
              ),),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  Image.asset(
                      "assets/images/fingerprint.png",
                      width: 120.0,
                  ),
                  Text(
                    "Biometric Authenticator",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Authenticate using your fingerprint",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, height: 1.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        _authenticate();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        primary: Colors.blue,
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        "Authenticate with fingerprint",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          _authenticate();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                          primary: Colors.blue,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          "Authenticate with face",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
