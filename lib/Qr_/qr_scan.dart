import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayaan/Qr_/qr_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prayaan/Admin/studentprofile.dart';

import '../Mainmenu/Page3.dart';

class QRreader1 extends StatefulWidget {
  @override
  _QRreader1State createState() => _QRreader1State();
}

class _QRreader1State extends State<QRreader1> {
  var _latitude =Timestamp.now();
  var _longitude ="";
  var _altitude="";
  var _speed ="";
  var _address = "";
  String  Time="";

  Future<void>_updatePosition() async {
    Position pos = await _determinePosition();
    List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {

      _longitude = pos.longitude.toString();
      _altitude = pos.altitude.toString();
      _speed = pos.speed.toString();
      _address = pm[0].toString();
    });
  }
  Future <Position>_determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permanently denied,we cannot request permissions.");
    }
    return await Geolocator.getCurrentPosition();
  }


  // Explicit


  // Method



  Future<void> qrProcess() async {
    try {
      String codeString =  BarcodeScanner.scan() as String;

      await FirebaseFirestore.instance.collection('Qr Data').doc('qr').snapshots().forEach((element) {
        if(element.data()?['qrdata'] == codeString ){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Studentprofile()), (route) => false);
        }

      });


    } catch (e) {}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QR Scanner', style: TextStyle(fontSize: 22,color: Colors.black),),
          backgroundColor: Colors.grey,
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(

                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bg.jpg'),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.color),
                      fit: BoxFit.fill,
                    )),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),

                          MaterialButton(
                            onPressed: () async{
                              qrProcess();



                              Map <String,dynamic> data= {'User Id':user.email,"Signout Location":"Vadakara"};
                              final docUser= FirebaseFirestore.instance.collection('Student Register').doc(user.email);
                              docUser.set(data);
                            },





                            child: Text(
                              'Scan Your Bar Code',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Theme.of(context).primaryColor, //Color(0xffff2d55),
                            elevation: 10,
                            minWidth: 300,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.white),),
                          ),])))));
  }
}