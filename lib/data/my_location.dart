import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class MyLocation {
  double latitude2 = 0;
  double longitude2 = 0;

   Future <void> getMyCurrentLocation() async {
    // 위치 권한 확인
    var status = await Permission.location.request();
    if (status.isGranted) {
      // 위치 정보 가져오기
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude2 = position.latitude;
        longitude2 = position.longitude;
        print(latitude2);
        print(longitude2);
      } catch (e) {
        print('There was a problem retrieving the location: $e');
      }
    } else {
      print('Location permission denied by user.');
      // 사용자가 권한을 거부한 경우 처리
    }
  }
}
