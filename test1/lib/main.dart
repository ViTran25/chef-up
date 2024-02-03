import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
        // This works forge code too, not just values: Most code changes can be
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
            height: 500,
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
      ),],
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
              child: Image(image: AssetImage('images/MM.jpg'), //NOTE!!! containers cannot have children, only a single child.
            )
          )
,
            Container(
              width: 5000,
              height: 100,
              color: Colors.white,
              child: Image(image: AssetImage('images/MM.jpg'),
            )
          ),
            Container(
              width: 5000,
              height: 100,
              color: Colors.green,
              child: Image(image: AssetImage('images/MM.jpg'),
            )
          ),
            Container(
              width: 5000,
              height: 100,
              color: Colors.black,
              child: Image(image: AssetImage('images/MM.jpg'),
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