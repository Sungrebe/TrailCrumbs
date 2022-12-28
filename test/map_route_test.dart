import 'dart:async';

import 'package:crumbs/model/map_route.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Route tests', () {
    MapRoute exampleRoute = MapRoute();
    RoutePoint examplePoint1 = RoutePoint(
      latitude: 37.432483,
      longitude: -122.091763,
    );
    RoutePoint examplePoint2 = RoutePoint(
      latitude: 37.43251,
      longitude: -122.09173,
    );

    double mapWidth = 600;
    double mapHeight = 800;

    List<Offset> examplePixelList = [];

    test('updateTimeElapsed', () {
      int seconds = 0;
      expect(exampleRoute.timeElapsed, equals(Duration.zero));
      Timer.periodic(const Duration(seconds: 1), (timer) {
        seconds++;
        exampleRoute.updateTimeElapsed();
        expect(exampleRoute.timeElapsed, equals(Duration.zero + Duration(seconds: seconds)));
      });
    });

    test('updateDistanceTraveled', () {
      RoutePoint kilometerFromPoint1 = RoutePoint(
        latitude: 37.43821,
        longitude: -122.09811,
      );

      exampleRoute.updatePoints(examplePoint1);
      exampleRoute.updatePoints(kilometerFromPoint1);
      expect(exampleRoute.distanceTraveled, equals(0));
      exampleRoute.updateDistanceTraveled();
      expect(exampleRoute.distanceTraveled, closeTo(1000, 200));
    });

    test('updatePoints', () {
      exampleRoute.removeAll();

      expect(exampleRoute.numberOfPoints, equals(0));
      exampleRoute.updatePoints(examplePoint1);
      expect(exampleRoute.numberOfPoints, equals(1));

      double quarterMile = 0.0036231884;

      expect(exampleRoute.minLatitude, equals(examplePoint1.latitude - quarterMile));
      expect(exampleRoute.maxLatitude, equals(examplePoint1.latitude + quarterMile));
      expect(exampleRoute.minLongitude, equals(examplePoint1.longitude - quarterMile));
      expect(exampleRoute.maxLongitude, equals(examplePoint1.longitude + quarterMile));

      if (examplePoint2.latitude < exampleRoute.minLatitude) {
        expect(examplePoint2.latitude, equals(exampleRoute.minLatitude - quarterMile));
      } else if (examplePoint1.latitude > exampleRoute.maxLatitude) {
        expect(examplePoint2.latitude, equals(exampleRoute.maxLatitude + quarterMile));
      } else if (examplePoint1.longitude < exampleRoute.minLongitude) {
        expect(examplePoint2.longitude, equals(exampleRoute.minLongitude - quarterMile));
      } else if (examplePoint1.longitude > exampleRoute.maxLongitude) {
        expect(examplePoint1.longitude, equals(exampleRoute.maxLongitude + quarterMile));
      }
    });

    test('plotRoute', () {
      exampleRoute.updatePoints(examplePoint1);
      examplePixelList = exampleRoute.plotPoints(mapWidth, mapHeight);

      expect(examplePixelList.first.dx, equals(mapWidth / 2));
      expect(examplePixelList.first.dy, equals(mapHeight / 2));
    });

    test('drawLineBetweenPixels', () {
      exampleRoute.updatePoints(examplePoint1);
      exampleRoute.updatePoints(examplePoint2);
      examplePixelList = exampleRoute.plotPoints(mapWidth, mapHeight);

      var exampleRoutePath = exampleRoute.drawLineBetweenPixels(examplePixelList);
      expect(exampleRoutePath.contains(examplePixelList[1]), equals(true));
    });
  });
}