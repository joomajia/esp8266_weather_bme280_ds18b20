import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import 'secondpage.dart';

void main() {
  runApp(MyApp());
}

class TemperatureData {
  final int minutes;
  final double temperature;

  TemperatureData({required this.minutes, required this.temperature});
}

class TemperatureDataBME {
  final int minutesBME;
  final double temperatureBME;

  TemperatureDataBME({required this.minutesBME, required this.temperatureBME});
}

class pressureDataBME {
  final int minutesBME;
  final double pressureBME;

  pressureDataBME({required this.minutesBME, required this.pressureBME});
}

class humidityDataBME {
  final int minutesBME;
  final double humidityBME;

  humidityDataBME({required this.minutesBME, required this.humidityBME});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP8266 Data Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final serverIP = '192.168.19.152';

List<TemperatureData> temperatureDS12B20DataList = [];
List<TemperatureDataBME> temperatureBMEDataList = [];
List<pressureDataBME> pressureDataList = [];
List<humidityDataBME> humidityDataList = [];

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    fetchData1();
    // fetchData2();
    // fetchData3();
  }

  Future<void> fetchData1() async {
    await fetchDataDS(
        'http://$serverIP:80/getFileTempDS18B20', temperatureDS12B20DataList);
  }

  // Future<void> fetchData2() async {
  //   await fetchDataBME(
  //       'http://$serverIP:80/getFileTempBME280', temperatureBMEDataList);
  // }

  // Future<void> fetchData4() async {
  //   await fetchData('http://$serverIP:80/getFileHumidBME280', humidityDataList);
  // }

  Future<void> fetchDataDS(String url, List<TemperatureData> dataList) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        List<TemperatureData> newDataItems = [];

        for (String line in lines) {
          List<String> values = line.split(' ');
          if (values.length == 2) {
            newDataItems.add(TemperatureData(
              minutes: int.parse(values[0]),
              temperature: double.parse(values[1]),
            ));
          }
        }
        setState(() {
          dataList.clear();
          dataList.addAll(newDataItems);
        });
      } else {
        throw Exception(
            'Failed to load data. Server responded with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Future<void> fetchDataBME(
  //     String url, List<TemperatureDataBME> dataListBME) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final List<String> lines = response.body.split('\n');
  //       List<TemperatureDataBME> newDataItemsBME = [];

  //       for (String line in lines) {
  //         List<String> values = line.split(' ');
  //         if (values.length == 2) {
  //           newDataItemsBME.add(TemperatureDataBME(
  //             minutesBME: int.parse(values[0]),
  //             temperatureBME: double.parse(values[1]),
  //           ));
  //         }
  //       }
  //       setState(() {
  //         dataListBME.clear();
  //         dataListBME.addAll(newDataItemsBME);
  //       });
  //     } else {
  //       throw Exception(
  //           'Failed to load data. Server responded with status code ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }
  // }

  // Future<void> fetchDataPressureBME(
  //     String url, List<pressureDataBME> dataListBME) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final List<String> lines = response.body.split('\n');
  //       List<pressureDataBME> newDataItemsBME = [];

  //       for (String line in lines) {
  //         List<String> values = line.split(' ');
  //         if (values.length == 2) {
  //           newDataItemsBME.add(pressureDataBME(
  //             minutesBME: int.parse(values[0]),
  //             pressureBME: double.parse(values[1]),
  //           ));
  //         }
  //       }
  //       setState(() {
  //         dataListBME.clear();
  //         dataListBME.addAll(newDataItemsBME);
  //       });
  //     } else {
  //       throw Exception(
  //           'Failed to load data. Server responded with status code ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }
  // }

  List<charts.Series<TemperatureData, String>> _getSeriesData1(
      List<TemperatureData> dataList) {
    return [
      charts.Series(
        id: "Temperature",
        data: dataList,
        domainFn: (TemperatureData series, _) => series.minutes.toString(),
        measureFn: (TemperatureData series, _) => series.temperature.toInt(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  // List<charts.Series<TemperatureDataBME, String>> _getSeriesData2(
  //     List<TemperatureDataBME> dataList) {
  //   return [
  //     charts.Series(
  //       id: "Temperature",
  //       data: dataList,
  //       domainFn: (TemperatureDataBME series, _) =>
  //           series.minutesBME.toString(),
  //       measureFn: (TemperatureDataBME series, _) =>
  //           series.temperatureBME.toInt(),
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //     )
  //   ];
  // }

  // List<charts.Series<pressureDataBME, String>> _getSeriesData3(
  //     List<pressureDataBME> dataList) {
  //   return [
  //     charts.Series(
  //       id: "Pressure",
  //       data: dataList,
  //       domainFn: (pressureDataBME series, _) => series.minutesBME.toString(),
  //       measureFn: (pressureDataBME series, _) => series.pressureBME.toInt(),
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //     )
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Датчик земля'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              // color: const Color.fromARGB(255, 237, 237, 237),
              height: 450,
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Температура по минутам (File 1)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _getSeriesData1(temperatureDS12B20DataList),
                          animate: true,
                          domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          fetchData1();
                        },
                        child: Text('Получить данные'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.all(10),
            //   // color: const Color.fromARGB(255, 237, 237, 237),
            //   height: 500,
            //   width: double.infinity,
            //   child: Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(3.0),
            //       child: Column(
            //         children: <Widget>[
            //           Text(
            //             "Температура по минутам (File 1)",
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           Expanded(
            //             child: charts.BarChart(
            //               _getSeriesData3(pressureDataList),
            //               animate: true,
            //               domainAxis: charts.OrdinalAxisSpec(
            //                   renderSpec: charts.SmallTickRendererSpec(
            //                       labelRotation: 60)),
            //             ),
            //           ),
            //           ElevatedButton(
            //             onPressed: () {
            //               // fetchData3();
            //             },
            //             child: Text('Получить данные'),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the second page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage()),
          );
        },
        child: Icon(Icons.navigate_next),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    
    );
  }
}

class BottomAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(height: 50.0),
    );
  }
}
