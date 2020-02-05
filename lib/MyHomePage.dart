import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'user_location.dart';
import 'package:imperator_app/mis_widgets.dart';
import 'mis_funciones.dart';

//Guía: https://medium.com/@anticafe/is-it-possible-to-customize-infowindow-c42eb4e83cc1

//Creamos un W de 'CameraPosition' llamado _posicionInicial (privado) el cual tendrá un target determinado por la
// latitud y longitud.
//CameraPosition _posicionInicial = CameraPosition(target: LatLng(26.8206, 30.8025));

//Creamos un controlador para las opciones especificas del mapa.
Completer<GoogleMapController> _controlador = Completer();

//Creamos un set de marcadores (Un set no tiene un orden para cada elemento UNICO).
Set<Marker> _marcadores = Set();

Future<void> desplazarMapa(double lat, double long, _zoom) async {
  //Creamos un controlador
  GoogleMapController controlador = await _controlador.future;
  //Ejecutamos su método 'animateCamera', actualizando la camara con una nueva lat y long, y con un zoom.
  controlador
      .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
}

//Función que se encarga de establecer el controlador del mapa.
void _mapaCreado(GoogleMapController controlador) {
  _controlador.complete((controlador));
}

//
List<Widget> tarjetasVisual = [
  SizedBox(
    width: 10.0,
  ),
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double uLatitude;
  double uLongitude;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = true;
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    UserLocation userLocation = UserLocation();
    await userLocation.getCurrentLocation();
    setState(() {
      uLatitude = userLocation.uLatitude;
      uLongitude = userLocation.uLongitude;
      loading = false;
    });
    print(uLatitude);
    print(uLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            loading == false
                ? GoogleMap(
                    markers: _marcadores,
                    onMapCreated: _mapaCreado,
                    myLocationEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(24, 9), zoom: 14.0),
                  )
                : CircularProgressIndicator(),
            ContenedoresRestaurante(),
            FloatingActionButton(
              onPressed: () async {
                DetallesTarjeta nuevoDetalle = DetallesTarjeta();
                await AlertaTexo().mostrarDialogo(context, nuevoDetalle);
                setState(() {
                  addNegocio(nuevoDetalle, tarjetasVisual, _marcadores);
                });
              },
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
