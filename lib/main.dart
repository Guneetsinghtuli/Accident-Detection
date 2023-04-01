import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:location/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void main() {
  runApp(MyApp());
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

  sendEmail()async{
    final Email send_email = Email(
      body: 'body of email',
      subject: 'subject of email',
      recipients: ['guneetsinghtuli@gmail.com'],
      // cc: ['example_cc@ex.com'],
      // bcc: ['example_bcc@ex.com'],
      // attachmentPaths: ['/path/to/email_attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(send_email);
    print("Send Emails");
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _xData.add(DataPoint(_xData.length, event.x));
        _yData.add(DataPoint(_yData.length, event.y));
        _zData.add(DataPoint(_zData.length, event.z));
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
    // getLocationPermission();
    getLocation();
    sendEmail();
  }

  // Widget scafold =  Scaffold(
  //   appBar: AppBar(
  //     title: const Text('Accelerometer Chart'),
  //   ),
  //   body: Column(
  //       children: [
  //         // Text("Crash"),
  //         Center(
  //           child: SfCartesianChart(
  //             primaryXAxis: NumericAxis(
  //
  //             ),
  //             series: <LineSeries<DataPoint, int>>[
  //               LineSeries<DataPoint, int>(
  //                 dataSource: _xData,
  //                 xValueMapper: (DataPoint point, _) => point.x,
  //                 yValueMapper: (DataPoint point, _) => point.y,
  //                 name: 'X',
  //               ),
  //               LineSeries<DataPoint, int>(
  //                 dataSource: _yData,
  //                 xValueMapper: (DataPoint point, _) => point.x,
  //                 yValueMapper: (DataPoint point, _) => point.y,
  //                 name: 'Y',
  //               ),
  //               LineSeries<DataPoint, int>(
  //                 dataSource: _zData,
  //                 xValueMapper: (DataPoint point, _) => point.x,
  //                 yValueMapper: (DataPoint point, _) => point.y,
  //                 name: 'Z',
  //               ),
  //             ],
  //           ),
  //         ),]
  //   ),
  // );


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
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
              child: Column(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,color: Colors.white,),
                              SizedBox(
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
                        Container(),
                        Container()
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
                                    Text("Furquan ka Papa",style: GoogleFonts.poppins(
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
                                      Text("Aadya ka Papa",style: GoogleFonts.poppins(
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
                                      Text("Geetisha Harami",style: GoogleFonts.poppins(
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
            ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Color.fromRGBO(0, 232, 152, 1),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.home_filled)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.graphic_eq)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  final int x;
  final double y;

  DataPoint(this.x, this.y);
}
