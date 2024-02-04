import 'package:dio/dio.dart';
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
  static const trucks = [
      Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(40.444990, -79.940640),
        child: Icon(
          Icons.location_on_rounded,
          color: Colors.red,
          size: 50.0,
        )
      ),
      Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(40.444490, -79.943640),
        child: Icon(
          Icons.location_on_rounded,
          color: Colors.blue,
          size: 50.0,
        )
      ),
      Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(40.444019, -79.954590),
        child: Icon(
          Icons.location_on_rounded,
          color: Colors.purple,
          size: 50.0,
        )
      ),
      Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(40.445490, -79.942640),
        child: Icon(
          Icons.location_on_rounded,
          color: Colors.green,
          size: 50.0,
        )
      ),
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
  @override
  void initState() {
    super.initState();
  }
  
  // I don't what are those for
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  // The very top widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web Map'),
        backgroundColor: const Color.fromARGB(255, 55, 136, 105), // Optional background color,
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
  const Truckview({super.key, required this.title, this.trucks});
  final String title;
  final trucks;

  @override
  State<Truckview> createState() => _Truckview(trucks: trucks);
}

class _Truckview extends State<Truckview> {
  _Truckview({this.trucks});
  final trucks;

  late bool servicePermission = false;
  late LocationPermission permission;
  @override
  Widget build(BuildContext context) {

    Future<Position> getCurrentLocation() async {

      permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied)
      {
        permission = await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text("Broadcast my Location"),
            onPressed: () {
              getCurrentLocation().then((position) {
                trucks.add(
                  Marker(
                    point: LatLng(position.latitude, position.longitude), 
                    width: 30.0,
                    height: 30.0,
                    child: const Icon(
                      Icons.local_shipping, color: Color.fromARGB(255, 136, 89, 1)
                    )
                  )
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mapview(title: "map", trucks: trucks)),
                );
              });
            }
          )
        )
      )
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
  LatLng userLocation = LatLng(40.443490, -79.941640);
  LatLng truck1Location = LatLng(40.444990, -79.940640);
  LatLng truck2Location = LatLng(40.444490, -79.943640);
  LatLng truck3Location = LatLng(40.444019, -79.954590);
  LatLng truck4Location = LatLng(40.445490, -79.942640);

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //Add Header if needed
      appBar: AppBar(
        title: Text('Flutter Web Map'),
        backgroundColor: Color.fromARGB(255, 55, 136, 105), // Optional background color,
      ),
      //Main Body for the Web, note that it is written as a column
      body: Column(
        //Direction of the column orientation
        verticalDirection: VerticalDirection.down,

          //Items in the column
        children: [
          //First item in the column, the flutter map
          SizedBox(
            width:5000,
            height: 430,
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
                  markers: [
                  Marker(point: userLocation, width: 30.0, height: 30.0, child: const Icon(Icons.person)), ... trucks]
                ),
                PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeCoordinates,
                        color: Colors.blue,
                        strokeWidth: 8.0,
                      )
                    ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: userLocation,
                      child: Icon(
                        Icons.person,
                        color: Colors.pink,
                        size: 30.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck1Location,
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.red,
                        size: 30.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck2Location,
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.blue,
                        size: 30.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck3Location,
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.purple,
                        size: 30.0,
                      )
                    ),
                    Marker(
                      width: 30.0,
                      height: 30.0,
                      point: truck4Location,
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.orange,
                        size: 30.0,
                      )
                    ),
                  ]
                ),
                PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeCoordinates,
                        color: Colors.blue,
                        strokeWidth: 3.0,
                      )
                    ],
                ),
              ],
            )
          ),


      //The "Menu" for all the food trucks with their pictures and title and descriptions.
      //Edit the containers to will
          SizedBox(
            //Dimensions for the ListView
            width: double.infinity,
            height: 170,

            child: ListView(
              //Items in the ListView
              children: [

            ElevatedButton(
              onPressed: (){
                routeCoordinates.clear();
                fetchRoute(startLocation: userLocation, endLocation: truck1Location);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                  minimumSize: MaterialStateProperty.all(Size(130, 40)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),)),
                  ),
              child: 
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 5000,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(image: AssetImage('images/MM.jpg')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                            Text("      "),
                            Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
        ]
    )
]
          )
        )
      ),

            ElevatedButton(
              onPressed: (){
                routeCoordinates.clear();
                fetchRoute(startLocation: userLocation, endLocation: truck2Location);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all(Size(130, 40)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),)),
                  ),
              child: 
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 5000,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(image: AssetImage('images/MM.jpg')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                            Text("      "),
                            Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
        ]
    )
]
          )
        )
      ),

            ElevatedButton(
              onPressed: (){
                routeCoordinates.clear();
                fetchRoute(startLocation: userLocation, endLocation: truck3Location);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                  minimumSize: MaterialStateProperty.all(Size(130, 40)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),)),
                  ),
              child: 
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 5000,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(image: AssetImage('images/MM.jpg')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                            Text("      "),
                            Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
        ]
    )
]
          )
        )
      ),

            ElevatedButton(
              onPressed: (){
                routeCoordinates.clear();
                fetchRoute(startLocation: userLocation, endLocation: truck4Location);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
                  minimumSize: MaterialStateProperty.all(Size(130, 40)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),)),
                  ),
              child: 
                Container(
                  width: 5000,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(image: AssetImage('images/MM.jpg')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Text("Miwa Kasumi", style: const TextStyle(fontWeight: FontWeight.bold)), //Name of Food truck
                            Text("      "),
                            Text("The greatest Jujutsu Sorcerer of all time.") //Description of food truck
        ]
    )
]
          )
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