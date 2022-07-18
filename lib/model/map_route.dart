import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RoutePoint {
  double latitude;
  double longitude;

  RoutePoint({required this.latitude, required this.longitude});
}

class MapRoute extends ChangeNotifier {
  final List<RoutePoint> _points = [];
  StreamSubscription<Position>? _subscription;
  final _stopwatch = Stopwatch();

  double distanceTraveled = 0;

  int locationReadings = 0;
  double minLatitude = double.negativeInfinity;
  double maxLatitude = double.infinity;
  double minLongitude = double.negativeInfinity;
  double maxLongitude = double.infinity;

  int get numberOfPoints => _points.length;

  String formatTimeElapsed() {
    Duration timeElapsed = _stopwatch.elapsed;

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(timeElapsed.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(timeElapsed.inSeconds.remainder(60));
    return "${twoDigits(timeElapsed.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String getDistanceTraveled() {
    double distance = 0;

    if (_points.isNotEmpty) {
      distance = Geolocator.distanceBetween(
        _points.first.latitude,
        _points.first.longitude,
        _points.last.latitude,
        _points.last.longitude,
      );
    }

    return distance.toStringAsFixed(1);
  }

  void recordPosition() {
    if (_points.isNotEmpty) {
      _points.clear();
    }

    _stopwatch.start();
    LocationSettings settings = const LocationSettings(distanceFilter: 10);
    _subscription = Geolocator.getPositionStream(locationSettings: settings).listen((Position pos) {
      locationReadings++;
      update(RoutePoint(latitude: pos.latitude, longitude: pos.longitude));
    });
  }

  void stopRecordPosition() {
    _subscription?.cancel();
  }

  void update(RoutePoint point) {
    _points.add(point);
    notifyListeners();

    double quarterMileOffset = 0.0036231884;
    var lastPoint = _points.last;
    if (_points.length == 1) {
      minLatitude = (lastPoint.latitude - quarterMileOffset);
      maxLatitude = (lastPoint.latitude + quarterMileOffset);
      minLongitude = (lastPoint.longitude - quarterMileOffset);
      maxLongitude = (lastPoint.longitude + quarterMileOffset);
    } else {
      if (lastPoint.latitude < minLatitude) {
        minLatitude = (lastPoint.latitude - quarterMileOffset);
        notifyListeners();
      } else if (lastPoint.latitude > maxLatitude) {
        maxLatitude = (lastPoint.latitude + quarterMileOffset);
        notifyListeners();
      } else if (lastPoint.longitude < minLongitude) {
        minLongitude = (lastPoint.longitude - quarterMileOffset);
        notifyListeners();
      } else if (lastPoint.longitude > maxLongitude) {
        maxLongitude = (lastPoint.longitude + quarterMileOffset);
        notifyListeners();
      }
    }
  }

  List<Offset> plotPoints(double mapWidth, double mapHeight) {
    List<Offset> pixels = [];

    for (var point in _points) {
      var pixelX = (minLatitude - point.latitude) / (minLatitude - maxLatitude) * mapWidth;
      var pixelY = (maxLongitude - point.longitude) / (maxLongitude - minLongitude) * mapHeight;

      pixels.add(Offset(pixelX, pixelY));
    }

    return pixels;
  }

  Path drawLineBetweenPixels(List<Offset> listOfPixels) {
    var routePath = Path();

    for (int i = 1; i < listOfPixels.length; i++) {
      routePath
        ..moveTo(listOfPixels[i - 1].dx, listOfPixels[i - 1].dy)
        ..lineTo(listOfPixels[i].dx, listOfPixels[i].dy);
    }

    return routePath;
  }
}