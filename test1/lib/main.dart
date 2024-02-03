import 'dart:html';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const trucks = [
      Marker(
        point: LatLng(40.443490, -79.941640),
        width: 80,
        height: 80,
        child: const Icon(Icons.location_on, color: Colors.blue, size: 30.0)
      )
    ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ChefUp', trucks: trucks),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.trucks});

  final String title;
  final trucks;

  @override
  State<MyHomePage> createState() => _MyHomePageState(trucks: trucks);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.trucks});
  final trucks;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Trucker!'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Truckview(title: "Truck", trucks: trucks)),
                );
              }
            ),
            ElevatedButton(
              child: const Text('User!'),
              onPressed: () {
                // Navigate to second route when tapped.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mapview(title: "map", trucks: trucks)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Truckview extends StatefulWidget {
  const Truckview({super.key, required this.title, trucks});
  final String title;

  @override
  State<Truckview> createState() => _Truckview();
}

class _Truckview extends State<Truckview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
    );
  }
}

class Mapview extends StatefulWidget {
  const Mapview({super.key, required this.title, this.trucks});

  final String title;
  final trucks;

  @override
  State<Mapview> createState() => _Mapview(trucks: trucks);
}

class _Mapview extends State<Mapview> {

  _Mapview({this.trucks});
  final trucks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //Add Header if needed
  
      //Main Body for the Web, note that it is written as a column
      body: Column(
        //Direction of the column orientation
        verticalDirection: VerticalDirection.down,

          //Items in the column
        children: [
          //First item in the column, the flutter map
          Container(
            width:5000,
            height: 496,
            child: FlutterMap(
              
              options: const MapOptions(
                initialCenter: LatLng(40.443490, -79.941640),
                initialZoom: 17.2,
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
                  ],
                ),
                MarkerLayer(
                  markers: trucks
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    child: const Text('Home'),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                ),
              ],
            )
          ),


      //The "Menu" for all the food trucks with their pictures and title and descriptions.
      //Edit the containers to will
          Container(
            //Dimensions for the ListView
            width: double.infinity,
            height: 300,

            child: ListView(
              //Items in the ListView
              children: [
                Container(
                  width: 5000,
                  height: 100,
                  color: Colors.red,
                  child: const Image(image: AssetImage('images/MM.jpg'), //NOTE!!! containers cannot have children, only a single child.
                    )
                ),

                Container(
                  width: 5000,
                  height: 100,
                  color: Colors.white,
                  child: const Image(image: AssetImage('images/MM.jpg'),
                  )
                ),
                Container(
                  width: 5000,
                  height: 100,
                  color: Colors.green,
                  child: const Image(image: AssetImage('images/MM.jpg'),
                  )
                ),
                Container(
                  width: 5000,
                  height: 100,
                  color: Colors.black,
                  child: const Image(image: AssetImage('images/MM.jpg'),
                  )
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}
