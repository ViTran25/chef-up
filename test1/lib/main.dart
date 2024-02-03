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
    late Position _currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;

    void initState() {
    super.initState();
    _getCurrentLocation().then((position) {
      setState(() {
        _currentLocation = position;
      });
    });
  }


    Future<Position> _getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();

      if(servicePermission == false)
      {
        print("Service Disabled");
      }

      permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied)
      {
        permission = await Geolocator.requestPermission();
      }

      return await Geolocator.getCurrentPosition();
    }


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
              
              options: MapOptions(
                initialCenter: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
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
                Align(alignment: Alignment.topRight,
                  child: ElevatedButton(
                    child: Text('getPos'),
                    onPressed: () async {
                      _currentLocation = await _getCurrentLocation();
                    },))
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

            ElevatedButton(
              onPressed: (){},
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
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
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

            ElevatedButton(
              onPressed: (){},
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
              onPressed: (){},
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
