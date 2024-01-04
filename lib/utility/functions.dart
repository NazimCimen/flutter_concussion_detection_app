import 'dart:math';
import 'package:sensorapp/ui/home_view.dart';
import 'package:sensors_plus/sensors_plus.dart';

double calculateAcceleration(AccelerometerEvent event) {
  return sqrt((event.x * event.x) + (event.y * event.y) + (event.z * event.z));
}

////////////////////// // Buffer'a ivme vektörü ekle
void addToBuffer4(double acceleration) {
  if (accelerationBuffer.length >= 4) {
    // Buffer 4 elemanlıysa ilk elemanı çıkar
    accelerationBuffer.removeAt(0);
  }
  // Buffer'a yeni ivme vektörünü ekle
  accelerationBuffer.add(acceleration);

  // Buffer'ı yazdır (isteğe bağlı)
  //   print("Buffer: $accelerationBuffer");
}

////////////////////////////////////////////////////
void addToBuffer2(double ortalamaIvme) {
  if (turevBuffer.length >= 2) {
    // Buffer 4 elemanlıysa ilk elemanı çıkar
    turevBuffer.removeAt(0);
  }
  // Buffer'a yeni ivme vektörünü ekle
  turevBuffer.add(ortalamaIvme);

  // Buffer'ı yazdır (isteğe bağlı)
  // print("Buffer: $turevBuffer");
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
  // İvme vektörlerinin ardışık ölçümler arasındaki farkları hesapla
  if (accelerationBuffer.length >= 2) {
    return (accelerationBuffer[1] - accelerationBuffer[0]) / period;
  }
  return 0;
}
