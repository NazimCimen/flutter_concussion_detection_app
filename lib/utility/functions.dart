import 'dart:math';
import 'package:sensorapp/ui/home_view.dart';
import 'package:sensors_plus/sensors_plus.dart';

double calculateAcceleration(AccelerometerEvent event) {
  return sqrt((event.x * event.x) + (event.y * event.y) + (event.z * event.z));
}

////////////////////// // Buffer'a ivme vektörü eklenir
void addToBuffer4(double acceleration) {
  if (accelerationBuffer.length >= 4) {
    accelerationBuffer.removeAt(0);
  }
  accelerationBuffer.add(acceleration);

}

////////////////////////////////////////////////////
void addToBuffer2(double ortalamaIvme) {
  if (turevBuffer.length >= 2) {
    turevBuffer.removeAt(0);
  }
  turevBuffer.add(ortalamaIvme);

}

////////////////////////////////////////////////////////////
double toplam = 0;
double ortalamaBul() {
  toplam = 0;
  for (int i = 0; i < accelerationBuffer.length; i++) {
    toplam = accelerationBuffer[i] + toplam;
  }
  return toplam / 4;
}

///////////////////////////////////////////

double ortalamaTurevFiltresi() {
  toplam = 0;
  double turev = 0;

  turev = ((turevBuffer[0] - turevBuffer[1]).abs()) / period;
  print('türev deger,: $turev');
  print(
      '-----------------------------------------------------------------------------');

  return turev;
}

/////////////////////////////////////////////////////
double turevHesapla() {
  if (accelerationBuffer.length >= 2) {
    return (accelerationBuffer[1] - accelerationBuffer[0]) / period;
  }
  return 0;
}
