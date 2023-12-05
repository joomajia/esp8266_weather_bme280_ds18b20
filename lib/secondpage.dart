import 'package:esp8266_weather_bme280_ds18b20/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void initState() {
    super.initState();
    // fetchData1();
    fetchData2();
    fetchData3();
    fetchData4();
  }

  Future<void> fetchDataBME(
      String url, List<TemperatureDataBME> dataListBME) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        List<TemperatureDataBME> newDataItemsBME = [];

        for (String line in lines) {
          List<String> values = line.split(' ');
          if (values.length == 2) {
            newDataItemsBME.add(TemperatureDataBME(
              minutesBME: int.parse(values[0]),
              temperatureBME: double.parse(values[1]),
            ));
          }
        }
        setState(() {
          dataListBME.clear();
          dataListBME.addAll(newDataItemsBME);
        });
      } else {
        throw Exception(
            'Failed to load data. Server responded with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchData2() async {
    await fetchDataBME(
        'http://$serverIP:80/getFileTempBME280', temperatureBMEDataList);
  }

  Future<void> fetchData3() async {
    await fetchDataPressureBME(
        'http://$serverIP:80/getFilePressBME280', pressureDataList);
  }

  Future<void> fetchData4() async {
    await fetchDataHumidBME(
        'http://$serverIP:80/getFileHumidBME280', humidityDataList);
  }

  Future<void> fetchDataPressureBME(
      String url, List<pressureDataBME> dataListBME) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        List<pressureDataBME> newDataItemsBME = [];

        for (String line in lines) {
          List<String> values = line.split(' ');
          if (values.length == 2) {
            newDataItemsBME.add(pressureDataBME(
              minutesBME: int.parse(values[0]),
              pressureBME: double.parse(values[1]),
            ));
          }
        }
        setState(() {
          dataListBME.clear();
          dataListBME.addAll(newDataItemsBME);
        });
      } else {
        throw Exception(
            'Failed to load data. Server responded with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchDataHumidBME(
      String url, List<humidityDataBME> dataListBME) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        List<humidityDataBME> newDataItemsBME = [];

        for (String line in lines) {
          List<String> values = line.split(' ');
          if (values.length == 2) {
            newDataItemsBME.add(humidityDataBME(
              minutesBME: int.parse(values[0]),
              humidityBME: double.parse(values[1]),
            ));
          }
        }
        setState(() {
          dataListBME.clear();
          dataListBME.addAll(newDataItemsBME);
        });
      } else {
        throw Exception(
            'Failed to load data. Server responded with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<charts.Series<TemperatureDataBME, String>> _getSeriesData2(
      List<TemperatureDataBME> dataList) {
    return [
      charts.Series(
        id: "Temperature",
        data: dataList,
        domainFn: (TemperatureDataBME series, _) =>
            series.minutesBME.toString(),
        measureFn: (TemperatureDataBME series, _) =>
            series.temperatureBME.toInt(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  List<charts.Series<pressureDataBME, String>> _getSeriesData3(
      List<pressureDataBME> dataList) {
    return [
      charts.Series(
        id: "Pressure",
        data: dataList,
        domainFn: (pressureDataBME series, _) => series.minutesBME.toString(),
        measureFn: (pressureDataBME series, _) => series.pressureBME.toInt(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  List<charts.Series<humidityDataBME, String>> _getSeriesData4(
      List<humidityDataBME> dataList) {
    return [
      charts.Series(
        id: "Pressure",
        data: dataList,
        domainFn: (humidityDataBME series, _) => series.minutesBME.toString(),
        measureFn: (humidityDataBME series, _) => series.humidityBME.toInt(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Датчик воздух'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Температура'),
              Tab(text: 'Давление'),
              Tab(text: 'Влажность'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              // color: const Color.fromARGB(255, 237, 237, 237),
              height: 500,
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Температура",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _getSeriesData2(temperatureBMEDataList),
                          animate: true,
                          domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          fetchData2();
                        },
                        child: Text('Получить данные'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              // color: const Color.fromARGB(255, 237, 237, 237),
              height: 500,
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Давление",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _getSeriesData3(pressureDataList),
                          animate: true,
                          domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          fetchData3();
                        },
                        child: Text('Получить данные'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              // color: const Color.fromARGB(255, 237, 237, 237),
              height: 500,
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Влажность",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _getSeriesData4(humidityDataList),
                          animate: true,
                          domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                           fetchData4();
                        },
                        child: Text('Получить данные'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 20.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
          child: Icon(Icons.navigate_before),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}
