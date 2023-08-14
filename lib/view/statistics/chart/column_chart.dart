import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/Const/const.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../const/ext.dart';
import 'chart_data.dart';

class ColumnChart extends StatefulWidget {
  final String title;
  final Color color;
  final String year;
  final List<ChartData> data;
  const ColumnChart({
    super.key,
    required this.title,
    required this.color,
    required this.data,
    required this.year,
  });

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    data = widget.data;
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile() ? Get.width : (Get.width > 800 ? 0.35.sw : Get.width),
        minWidth: 200,
      ),
      margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.5),
            offset: const Offset(0, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: widget.color,
              fontSize: 17,
            ),
          ),
          hr(),
          Container(
            constraints: BoxConstraints(
              maxHeight: isMobile() ? 300 : 500,
            ),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                //interval: 1,
                //visibleMinimum: 0,
                //visibleMaximum: Get.width > 600 ? 10 : 5,
                labelRotation: 45,
              ),
              primaryYAxis: NumericAxis(),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: widget.year,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                  color: widget.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
