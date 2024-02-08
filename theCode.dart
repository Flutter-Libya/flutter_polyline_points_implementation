import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    // أضف إحداثيات الموقع الابتدائي والوجهة هنا
    _addPolyline();
  }

  _addPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // أضف إحداثيات البداية والنهاية هنا
      PointLatLng(START_LAT, START_LNG),
      PointLatLng(END_LAT, END_LNG),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );
      setState(() {
        polylines[id] = polyline;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Polyline Example'),
      ),
      body: GoogleMap(
        polylines: Set<Polyline>.of(polylines.values),
        initialCameraPosition: CameraPosition(
          target: LatLng(START_LAT, START_LNG),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}

const double START_LAT = 37.7749;
const double START_LNG = -122.4194;
const double END_LAT = 37.7749; // أضف خطوط الطول للوجهة الخاصة بك
const double END_LNG = -122.5194; // أضف دائرة الطول للوجهة الخاصة بك
