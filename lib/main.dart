import 'dart:async';
import 'dart:convert';

import 'package:crash/graph.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

import 'addContact.dart';

void main() {
  runApp(Page());
}

class Page extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<DataPoint> _xData = List<DataPoint>.empty(growable: true);
  List<DataPoint> _yData = List<DataPoint>.empty(growable: true);
  List<DataPoint> _zData = List<DataPoint>.empty(growable: true);

  Location location = Location();
  String emai = "";
  String aliass = "";
  List help = [];


  sendEmail({required String name, required String email, required String subject, required String message})
    async{
      final service_id='service_z3f6q7v';
      final template_id='template_ckzthgm';
      final user_id='-E0ncx2VZtLENXFrp';

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
          url,
          headers:{
            'origin':'http://localhost',
            'Content-Type':'application/json',
          },
          body:json.encode({
      'service_id':service_id,
      'template_id':template_id,
      'user_id':user_id,
      'template_params':{
      'user_name':name,
      'user_email':email,
      'to-email':'guneetsingh@gmail.com',
      'user_subject':subject,
      'user_message':message,
      },
      }),
      );
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _xData.add(DataPoint(_xData.length, event.x));
        _yData.add(DataPoint(_yData.length, event.y));
        _zData.add(DataPoint(_zData.length, event.z));

        if (event.x > 2 && event.y > 2 && event.z > 12) {
          print('Warning: Acceleration limit exceeded');
        }
      });


    });
    Timer.periodic(Duration(seconds: 60), (Timer t) {
      // get the current timestamp
      final now = DateTime.now().millisecondsSinceEpoch;

      // remove elements from the x-axis data array
      while (_xData.isNotEmpty && now - _xData.first.x > 90000) {
        _xData.removeAt(0);
      }

      // remove elements from the y-axis data array
      while (_yData.isNotEmpty && now - _yData.first.x > 90000) {
        _yData.removeAt(0);
      }

      // remove elements from the z-axis data array
      while (_zData.isNotEmpty && now - _zData.first.x > 90000) {
        _zData.removeAt(0);
      }
    });

    // sendEmail(name: "Guneet", email: "guneetsinghtuli@Gmail.com", subject: "Check", message: "Chal gaya BC");
    getLocation();
  }

  changeStateAlias(String email,String alias){
    help.add({
      'email':email,
      'alias':alias
    });
    print(help);
  }

  changeStateEmail(){

  }
  submit(){

  }




  getLocation()async{
    print("Location");
    LocationData currentLocation = await location.getLocation();
    print(currentLocation.latitude);
    print(currentLocation.longitude);
    print(currentLocation.speed);
    print(currentLocation.speedAccuracy);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Don't Suffer",
                          style: GoogleFonts.poppins(
                              fontSize: 35, fontWeight: FontWeight.w600),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.help))
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 232, 152, 1),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "You are currently",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                            Container(
                              child: const Icon(
                                Icons.motorcycle_rounded,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ],
                        ),
                        Text("On Bike",style: GoogleFonts.montserrat(),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder:(BuildContext context)=> AddContact(change:changeStateAlias)));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add,color: Colors.white,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("Add Contacts for SOS",style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,

                                ),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(
                      10
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9))
                    ),

                    child: Column(
                      children: [
                        // ListView.builder(itemBuilder: (BuildContext context))
                        Card(
                          child: Container(
                            padding:EdgeInsets.all(12),
                            decoration:BoxDecoration(),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Furquan",style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,

                                    ),),
                                    Text("guneetsinghtuli@Gmail.com",style: GoogleFonts.poppins(
                                      fontSize: 11
                                    ),)
                                  ],
                                ),
                                Icon(Icons.delete)
                              ],
                            )
                          ),
                        ),
                        Card(
                          child: Container(
                              padding:EdgeInsets.all(12),
                              decoration:BoxDecoration(),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Aadya",style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,

                                      ),),
                                      Text("guneetsinghtuli@Gmail.com",style: GoogleFonts.poppins(
                                          fontSize: 11
                                      ),)
                                    ],
                                  ),
                                  Icon(Icons.delete)
                                ],
                              )
                          ),
                        ),
                        Card(
                          child: Container(
                              padding:EdgeInsets.all(12),
                              decoration:BoxDecoration(),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Geetisha",style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,

                                      ),),
                                      Text("guneetsinghtuli@Gmail.com",style: GoogleFonts.poppins(
                                          fontSize: 11
                                      ),)
                                    ],
                                  ),
                                  Icon(Icons.delete)
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(0, 232, 152, 1),
                    ),

                    child: Row(
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.home_filled)),
                        IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
                        IconButton(onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Graph(xData: _xData,yData: _yData,zData: _zData,)));
                        }, icon: const Icon(Icons.graphic_eq)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }
}


