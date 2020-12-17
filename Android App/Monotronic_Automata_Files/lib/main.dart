import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:image/image.dart' as Image;
import 'package:condition/condition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override

  
  double Temp=48;
  double CO2=1310;
  double CO=31;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight:  FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Color(0xFF21BFBD),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/Autonomous-car.jpg'),
                    radius: 50.0,
                  ),
                ),
                Text('Monotronic',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                    fontFamily: 'Montserrat')),
                SizedBox(width: 10.0),
                Text('Automata',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 210.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>BluetoothUI()));
                });
              },
              color: Color(0xFF21BFBD),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Connect',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Temperature\n(°C)',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomPaint(
                          foregroundPainter: CircleProgressTemp(Temp),
                          child: Container(
                          width: 200,
                          height: 200,
                          child: Center(child: Text(
                          "$Temp",
                          style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: (Temp>50)? Colors.red:Colors.black,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('                                    '),
                  IconButton(
                        onPressed: (){
                          Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>TempChart()));
                        },
                        icon: Icon(Icons.assessment_sharp),
                        iconSize: 50.0,
                        color: Colors.green,
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Carbon \nDioxide\n(ppm)             ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomPaint(
                          foregroundPainter: CircleProgressCO2(CO2),
                          child: Container(
                          width: 200,
                          height: 200,
                          child: Center(child: Text(
                          "$CO2",
                          style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: (CO2>1300)? Colors.red:Colors.black,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                    'Carbon \nMonoxide\n(ppm)',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                          CustomPaint(
                          foregroundPainter: CircleProgressCO(CO),
                          child: Container(
                          width: 200,
                          height: 200,
                          child: Center(child: Text(
                          "$CO",
                          style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: (CO>30)? Colors.red:Colors.black,
                    ),
                  )),
                ),
              ),
            ],
          ),
          Card(
            elevation: 10.0,
            color: Colors.black,
              child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  child: Conditioned(
                    cases: [
                      Case(Temp >=50, builder: () => Text('Temperature Very High! \nOpen doors and switch AC fan\n on full Blast',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      ),
                      ),
                    ],
                    defaultBuilder: () => Text('Looks like everything is Fine!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),),
                  ),
                ),
            ),
          ),
          Card(
            elevation: 10.0,
            color: Colors.black,
              child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  child: Conditioned(
                    cases: [
                      Case(CO2 >=1300, builder: () => Text('Carbon Dixide Level Increasing! \nStay safe while we do our job',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        fontFamily: 'Montserrat',
                      ),
                      ),
                      ),
                      Case(CO2 >=10000, builder: () => Text('DANGER!!! \nAC might be malfunctioning \nTurn it off and open windows!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      ),
                      ),
                    ],
                    defaultBuilder: () => Text('Looks like everything is Fine!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),),
                  ),
                ),
            ),
          ),
          Card(
            elevation: 10.0,
            color: Colors.black,
              child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  child: Conditioned(
                    cases: [
                      Case(CO >=30, builder: () => Text('Carbon Monoxide Level Increasing! \nStay safe while we do our job',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      ),
                      ),
                      Case(CO >=1000, builder: () => Text('DANGER!!! \nAC might be malfunctioning  \nPark the vehicle and vacate',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                      ),
                      ),
                    ],
                    defaultBuilder: () => Text('Looks like everything is Fine!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),),
                  ),
                ),
            ),
          ),
        ],
      ),
    ],
  ),
            ),
          ],
                    ),
                ],
              ),
            ),
                  ),
                ],
              )
            ),
        ],
      ),
    );
  }
}



//Circle Design for Carbon Monoxide
class CircleProgressCO extends CustomPainter{

  double CurrentProgress;

  CircleProgressCO(this.CurrentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle=Paint()
    ..strokeWidth=10
    ..color=Colors.black
    ..style=PaintingStyle.stroke;


    Paint completeArc=Paint()
    ..strokeWidth=10
    ..color=Colors.green[700]
    ..style=PaintingStyle.stroke
    ..strokeCap=StrokeCap.round;

    Offset center= Offset(size.width/2, size.height/2);
    double radius=min(size.width/2, size.height/2)-20;

    canvas.drawCircle(center, radius, outerCircle);
    double angle= 2*pi*(CurrentProgress/1000);

    canvas.drawArc(Rect.fromCircle(center:center, radius: radius), -pi/2, angle,false, completeArc);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

//Circle Design for Temperature
class CircleProgressTemp extends CustomPainter{

  double CurrentProgress;

  CircleProgressTemp(this.CurrentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle=Paint()
    ..strokeWidth=10
    ..color=Colors.black
    ..style=PaintingStyle.stroke;


    Paint completeArc=Paint()
    ..strokeWidth=10
    ..color=Colors.green[700]
    ..style=PaintingStyle.stroke
    ..strokeCap=StrokeCap.round;

    Offset center= Offset(size.width/2, size.height/2);
    double radius=min(size.width/2, size.height/2)-20;

    canvas.drawCircle(center, radius, outerCircle);
    double angle= 2*pi*(CurrentProgress/100);

    canvas.drawArc(Rect.fromCircle(center:center, radius: radius), -pi/2, angle,false, completeArc);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

//Circle Design for Carbon Dioxide
class CircleProgressCO2 extends CustomPainter{

  double CurrentProgress;

  CircleProgressCO2(this.CurrentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle=Paint()
    ..strokeWidth=10
    ..color=Colors.black
    ..style=PaintingStyle.stroke;


    Paint completeArc=Paint()
    ..strokeWidth=10
    ..color=Colors.green[700]
    ..style=PaintingStyle.stroke
    ..strokeCap=StrokeCap.round;

    Offset center= Offset(size.width/2, size.height/2);
    double radius=min(size.width/2, size.height/2)-20;

    canvas.drawCircle(center, radius, outerCircle);
    double angle= 2*pi*(CurrentProgress/10000);

    canvas.drawArc(Rect.fromCircle(center:center, radius: radius), -pi/2, angle,false, completeArc);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

//Temperature Chart Printer
class TempChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Chart"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: RotatedBox(quarterTurns: 3,
                  child: Text(
                    'Temperature(°C)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                  ),
                ),
              ),
              Container(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    // Initialize category axis
                                primaryXAxis: CategoryAxis(
                                  title: AxisTitle(
                                    text: 'Time(minutes)',
                                    textStyle: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                series: <ChartSeries>[
                                    // Initialize line series
                                    LineSeries<SalesData, double>(
                                        dataSource: [
                                            // Bind data source
                                            SalesData(0, 30),
                                            SalesData(10, 40.56),
                                            SalesData(20, 46.11),
                                            SalesData(30, 48.89),
                                            SalesData(40, 51.11),
                                            SalesData(50, 52.78),
                                            SalesData(60, 53.89),
                                        ],
                                        xValueMapper: (SalesData sales, _) => sales.temp,
                                        yValueMapper: (SalesData sales, _) => sales.sales,
                                        dataLabelSettings:DataLabelSettings(isVisible : true)
                        )
                      ]
                    ),
                )
                ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'Prediction Table',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:30.0),
          child: Table(
            children: [
              TableRow(
                  children: [
                    Text("15 mins",textScaleFactor: 1.5, style: TextStyle(fontWeight:FontWeight.bold)),
                    Text("30 mins",textScaleFactor: 1.5,style: TextStyle(fontWeight:FontWeight.bold)),
                    Text("60 mins",textScaleFactor: 1.5,style: TextStyle(fontWeight:FontWeight.bold)),
                  ]
                ),
                 TableRow(
                  children: [
                    Text("43.33°C",textScaleFactor: 1.5),
                    Text("48.89°C",textScaleFactor: 1.5),
                    Text("53.89°C",textScaleFactor: 1.5),
                  ]
                ),
                TableRow(
                  children: [
                    Text("42.78°C",textScaleFactor: 1.5),
                    Text("48.61°C",textScaleFactor: 1.5),
                    Text("53.78°C",textScaleFactor: 1.5),
                  ]
                ),
                TableRow(
                  children: [
                    Text("42.22°C",textScaleFactor: 1.5),
                    Text("48.33°C",textScaleFactor: 1.5),
                    Text("53.67°C",textScaleFactor: 1.5),
                  ]
                ),
                TableRow(
                  children: [
                    Text("41.67°C",textScaleFactor: 1.5),
                    Text("48.06°C",textScaleFactor: 1.5),
                    Text("53.56°C",textScaleFactor: 1.5),
                  ]
                ),
                TableRow(
                  children: [
                    Text("41.11°C",textScaleFactor: 1.5),
                    Text("47.78°C",textScaleFactor: 1.5),
                    Text("53.44°C",textScaleFactor: 1.5),
                  ]
                ),
            ],
          ),
        ),
        ],
      )
    );
  }
}

class SalesData{
        SalesData(this.temp, this.sales);
        final double temp;
        final double sales;
    }


class BluetoothUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth"),
          backgroundColor: Color(0xFF21BFBD),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(
                "Refresh",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              splashColor: Color(0xFF21BFBD),
              onPressed: (){},
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Enable Bluetooth',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "PAIRED DEVICES",
                          style: TextStyle(fontSize: 24, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Device:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RaisedButton(
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: new BorderSide(
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "DEVICE 1",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: (){},
                                  child: Text("ON"),
                                ),
                                FlatButton(
                                  onPressed: (){},
                                  child: Text("OFF"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.blue,
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 15),
                        RaisedButton(
                          elevation: 2,
                          child: Text("Bluetooth Settings"),
                          onPressed: () {},
                        ),
                      ],
                    ),
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