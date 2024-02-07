import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ChefUp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.75), // Adjust opacity as needed
                BlendMode.dstATop,
              ),
            )
          ),
          child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Trucker!'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Truckview(title: "truck")),
                  );
                }
              ),

              Text("    "),

              ElevatedButton(
                child: const Text('User!'),
                onPressed: () {
                  // Navigate to second route when tapped.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Mapview(title: "map")),
                  );
                },
              ),
            ],
          ),
      ),
      )
    );
  }
}

class Truckview extends StatefulWidget {
  const Truckview({super.key, required this.title});
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
  const Mapview({super.key, required this.title});

  final String title;

  @override
  State<Mapview> createState() => _Mapview();
}

class _Mapview extends State<Mapview> {
  LatLng userLocation = LatLng(40.441783, -79.956263);
  LatLng truck1Location = LatLng(40.444990, -79.940640);
  LatLng truck2Location = LatLng(40.444646, -79.954607);
  LatLng truck3Location = LatLng(40.444019, -79.954590);
  LatLng truck4Location = LatLng(40.445490, -79.942640);
  LatLng truck5Location = LatLng(40.445288, -79.953717);

  // Routing function
  final List<Marker> markers = [];
  List<LatLng> routeCoordinates = [];
 
  // This is the method for getting a route
  Future<void> fetchRoute({
    required LatLng startLocation,
    required LatLng endLocation,
  }) async {
    // Start point and end point
    final LatLng startPoint = startLocation;
    final LatLng endPoint = endLocation;

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
                Icons.person_2_rounded,
                color: Colors.lightBlueAccent,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //Add Header if needed
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              height: 4.0,
          )
        ),
        title: Text('Food Truck Map'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.greenAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
        ), // Optional background color,
      ),
      //Main Body for the Web, note that it is written as a column
      body: Column(
        //Direction of the column orientation
        verticalDirection: VerticalDirection.down,

          //Items in the column
        children: [
          //First item in the column, the flutter map
          Flexible(
            flex: 3,
            child: FlutterMap(
              
              options: MapOptions(
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
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    child: const Text('Home'),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: userLocation,
                      child: Icon(
                        Icons.circle,
                        color: const Color.fromARGB(255, 56, 58, 59),
                        size: 26.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: userLocation,
                      child: Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 20.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck1Location,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.red,
                        size: 50.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck2Location,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.blue,
                        size: 50.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck3Location,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.purple,
                        size: 50.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck4Location,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.orange,
                        size: 50.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck5Location,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.yellow,
                        size: 50.0,
                      )
                    ),
                  ]
                ),
                PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeCoordinates,
                        color: Colors.blue,
                        strokeWidth: 7.0,
                      )
                    ],
                ),
              ],
            )
          ),


      //The "Menu" for all the food trucks with their pictures and title and descriptions.
      //Edit the containers to will
          Expanded(
            flex: 1,
            child: ListView(
              //Items in the ListView
              children: [
                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      ),
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      routeCoordinates.clear();
                      fetchRoute(startLocation: userLocation, endLocation: truck1Location);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40), 
                      backgroundColor: Colors.transparent,
                    ),
                    child: 
                      Container(
                        width: 5000,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(image: AssetImage('images/MM.jpg')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                                  Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
                                ]
                            )
                          ]
                        )
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      ),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      routeCoordinates.clear();
                      fetchRoute(startLocation: userLocation, endLocation: truck2Location);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40), 
                      backgroundColor: Colors.transparent,
                    ),
                    child: 
                      Container(
                        width: 5000,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(image: AssetImage('images/MM.jpg')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                                  Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
                              ]
                            )
                          ]
                        )
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      ),
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      routeCoordinates.clear();
                      fetchRoute(startLocation: userLocation, endLocation: truck3Location);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40), 
                      backgroundColor: Colors.transparent,
                    ),
                    child: 
                      Container(
                        width: 5000,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(image: AssetImage('images/MM.jpg')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                                  Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
                              ]
                            )
                          ]
                        )
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      ),
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      routeCoordinates.clear();
                      fetchRoute(startLocation: userLocation, endLocation: truck4Location);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40), 
                      backgroundColor: Colors.transparent,
                    ),
                    child: 
                      Container(
                        width: 5000,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(image: AssetImage('images/MM.jpg')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                                  Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
                              ]
                            )
                          ]
                        )
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      ),
                    gradient: LinearGradient(
                      colors: [const Color.fromARGB(255, 216, 194, 0), Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      routeCoordinates.clear();
                      fetchRoute(startLocation: userLocation, endLocation: truck5Location);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40), 
                      backgroundColor: Colors.transparent,
                    ),
                    child: 
                      Container(
                        width: 5000,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(image: AssetImage('images/MM.jpg')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                                  Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
                              ]
                            )
                          ]
                        )
                      )
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}