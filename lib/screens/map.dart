import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanrakshan/screens/create_issue.dart';

class MapSample extends StatefulWidget {
  final User user;
  const MapSample({super.key, required this.user});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  CollectionReference student = FirebaseFirestore.instance.collection('issues');
  List issues = [];
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.5004481, 77.2520095),
    zoom: 14.4746,
  );
  final List<Marker> _markers = <Marker>[];
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await student.get();
    issues = querySnapshot.docs.map((doc) => doc.data()).toList();
    loadData();
    print(issues);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  loadData() async {
    for (int i = 0; i < issues.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(issues[i]["lat"], issues[i]["long"]),
        infoWindow:
            InfoWindow(title: issues[i]["type"], snippet: issues[i]["detail"]),
      ));
      setState(() {});
    }
    print(_markers.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markers),
        zoomControlsEnabled: false,
        onLongPress: (l) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateIssue(
                        location: l,
                      )));
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
