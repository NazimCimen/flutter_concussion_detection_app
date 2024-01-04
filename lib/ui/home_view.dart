import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sensorapp/utility/functions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

List<double> accelerationBuffer = [0, 0, 0, 0];
List<double> turevBuffer = [0, 0];
double x = 0;
double y = 0;
double z = 0;
double threshold = 5; // Sarsıntı eşiği
double period = 0.025;
String formattedvalue = "";
int orneksay = 0;
double toplamIvme = 0;

String formattedvaluefunction(double deger) {
  formattedvalue = deger.toStringAsFixed(1);
  return formattedvalue;
}

class _HomeViewState extends State<HomeView> {
  late DateTime lastUpdate = DateTime.now();
  getAcceleration() {
    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        DateTime now = DateTime.now();
        //her 25 saniye arayla ivme sensöründen verileri dinliyoruz
        if (now.difference(lastUpdate).inMilliseconds >= 25) {
          setState(() {
            x = event.x;
            y = event.y;
            z = event.z;
            //2.adım magnitude formulü yardımıyla ivme büyüklüğünü hesaplıyoruz
            double ivmeGenligi = calculateAcceleration(event);
            //3.adım genlik degerini 4 lük buffera atıyoruz
            addToBuffer4(ivmeGenligi);
            //4.adım bufferdaki verileri ortalama filtresinden geçiriyoruz. gürültüyü baskılamak için
            double ortalamaIvme = ortalamaBul();
            print('yerçekimli veri: $ortalamaIvme');
            //5.adım daha sonra 2 lik buffera atıyoruz
            addToBuffer2(ortalamaIvme);

            //2lik bufferdaki verileri türev filtresinden geçiriyoruz.türev filtresi ile yerçekimi ivmesinin etkisi kaybolur
            double filteredVector = ortalamaTurevFiltresi();

            //saniyede 40 örnek toplayarak sarsıntı değerinin kontrolünü sağlıyoruz
            orneksay = orneksay + 1;
            toplamIvme = (toplamIvme + filteredVector) * period;
            if (orneksay > 40) {
              if (toplamIvme > threshold) {
                showToastmsg();
                Vibration.vibrate(duration: 2000);
                orneksay = 0;
                toplamIvme = 0;
              }
            }

            lastUpdate = now;
          });
        }
      },
      onError: (error) {},
      cancelOnError: true,
    );
  }

  /////////////////////////////////////////////////////
  showToastmsg() => Fluttertoast.showToast(
        msg: 'DEPREM ALARMI',
        backgroundColor: Colors.red,
        fontSize: 20,
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
  @override
  void initState() {
    getAcceleration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amber[200],
        appBar: AppBar(
          backgroundColor: Colors.amber[800],
          centerTitle: true,
          title: Text(' İVME ÖLÇER SENSÖRÜ '),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(18, 2, 18, 0),
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: Image.asset('assets/deprem.png'), // <-- SEE HERE
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 5),
                    ),
                    Text(
                      "Sensör Dinleniyor",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    SpinKitRipple(
                      color: Colors.black,
                      size: 50,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 5),
                    ),
                    Text(
                      'Sarsıntı Şiddeti  : ${formattedvaluefunction((toplamIvme / 40))}',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.amber[800],
      centerTitle: true,
      title: Text(' İVME ÖLÇER SENSÖRÜ '),
    );
  }
}
