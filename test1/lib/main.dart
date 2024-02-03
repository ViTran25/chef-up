import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Marker> markers = [];
  List<LatLng> routeCoordinates = [];
  int _counter = 0;

  
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  // This is the method for getting a route
  Future<void> fetchRoute() async {
    // Start point and end point
    final LatLng startPoint = LatLng(40.444, -79.951640);
    final LatLng endPoint = LatLng(40.443490, -79.941640);

    // This is the OSRM api for finding a route between two points
    final String apiUrl =
        'http://router.project-osrm.org/route/v1/driving/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?geometries=geojson';

    // Get the response from OSRM server
    final Response<dynamic> response = await Dio().get(apiUrl);

    // Decode the response into a list of coordinates
    if (response.statusCode == 200) {
      final List<dynamic> coordinates = response.data['routes'][0]['geometry']['coordinates'];

      for (var coordinate in coordinates) {
        final double lat = coordinate[1];
        final double lng = coordinate[0];
        routeCoordinates.add(LatLng(lat, lng));
      }

      setState(() {
        markers.addAll([
          Marker(
            width: 30.0,
            height: 30.0,
            point: startPoint,
            child: Container(
              child: Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 160, 15, 244),
                size: 30.0,
              ),
            ),
          ),
          Marker(
            width: 30.0,
            height: 30.0,
            point: endPoint,
            child: Container(
              child: Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 30.0,
              ),
            ),
          ),
        ]);
      });
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }
  
  // I don't what are those for
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  // The very top widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web Map'),
        backgroundColor: Color.fromARGB(255, 55, 136, 105), // Optional background color,
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
          width: double.infinity,
          height: 100,
          child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Text('List 1'),
                Text('List 2'),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 500,
            child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(40.443490, -79.941640),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],),
                  MarkerLayer(
                    markers : markers,                 
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeCoordinates,
                        color: Colors.blue,
                        strokeWidth: 3.0,
                      )
                    ],
                  )
                ],
              ),
          ),
        ],
        )
    );
  }

}
