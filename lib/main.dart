import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:location/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

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
    Future sendEmail({
      required String name,
      required String email,
      required String subject,
      required String message
    }) async{
      final service_id='service_z3f6q7v';
      final template_id='template_ckzthgm';
      final user_id='-E0ncx2VZtLENXFrp';

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
          url,
        headers:{
            'origin':'http://localhost',
            'Content-Type':'application/json',
        }
        body:json.encode({
      'service_id':serviceId,
      'template_id':templateId,
      'user_id':userId,
      'template_params':{
        'user_name':name,
      'user_email':email,
      'to-email':'other@gmail.com',
      'user_subject':subject,
      'user_message':message,
      },
      }),
      );

      print(response.body);
    }

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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Don't Suffer",style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.w600
                      ),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.help))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 232, 152, 1),
                    borderRadius: BorderRadius.all(Radius.circular(7))
                  ),
                  padding: EdgeInsets.all(15),
                  child: Container(
                    child: Text("You are currently",style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),),
                  ),
                ),

              ],
            ),
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
