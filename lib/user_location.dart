import 'package:geolocator/geolocator.dart';

class UserLocation {
  double uLatitude;
  double uLongitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      uLatitude = position.latitude;
      uLongitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
