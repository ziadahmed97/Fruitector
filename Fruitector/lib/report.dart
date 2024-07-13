import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'http.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final int y;
  final Color color;
}

class ReportScreen extends StatefulWidget {
  final ReportData reportData;

  const ReportScreen({Key? key, required this.reportData}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0XFF246D48),
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF246D48),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Report',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF324F5E)),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 420,
                  width: 500,
                  child: ListView.separated(
                    itemCount: widget.reportData.responseWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.reportData.responseWidgets[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            CustomPaint(
              painter: CurveCustomPainter(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
              child: Material(
                color: Color(0XFFFFFFFF),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 190, top: 0),
                      child: Text(
                        'Total Analysis',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF324F5E)),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 161,
                            width: 319,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                  dataSource: [
                                    ChartData(
                                        'Fresh',
                                        widget.reportData.freshCount,
                                        Color(0XFF38B376)),
                                    ChartData(
                                        'Rotten',
                                        widget.reportData.rottenCount,
                                        Color(0XFFE84141)),
                                  ],
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 10.0,
                                    width: 15.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF38B376),
                                      // Hex color code for red
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Text(
                                    '${((widget.reportData.freshCount / (widget.reportData.freshCount + widget.reportData.rottenCount)) * 100).toStringAsFixed(0)}%  Fresh fruits',
                                    style: TextStyle(
                                        color: Color(0xFF96A7AF), fontSize: 14),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 10.0,
                                    width: 15.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE84141),
                                      // Hex color code for red
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Text(
                                    '${((widget.reportData.rottenCount / (widget.reportData.freshCount + widget.reportData.rottenCount)) * 100).toStringAsFixed(0)}% Rotten fruits ',
                                    style: TextStyle(
                                        color: Color(0xFF96A7AF), fontSize: 14),
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
            )
          ],
        ),
      ),
    );
  }
}

class CurveCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0XFF324F5E)
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;
    canvas.drawLine(Offset(-190, 0), Offset(190, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
