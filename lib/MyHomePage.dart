import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Guía: https://medium.com/@anticafe/is-it-possible-to-customize-infowindow-c42eb4e83cc1

//TODO: Obtener la pos del usuario y establecer al mapa con esa pos (Con permisos - Los cuales se supone que ya coloqué en los manifiestas de And e IOS)

//Creamos un W de 'CameraPosotion' llamado _posicionInicial (privado) el cual tendrá un target determinado por la
// latitud y longitud.
CameraPosition _posicionInicial =
    CameraPosition(target: LatLng(26.8206, 30.8025));

//Creamos un controlador para las opciones especificas del mapa.
Completer<GoogleMapController> _controlador = Completer();

//Creamos una variable que almacenará el zoom que realizará el mapa al desplazarse:
final double _zoom = 10;

//Creamos un set de marcadores (Un set no tiene un orden para cada elemento UNICO).
final Set<Marker> _marcadores = Set();

//Función que se encarga de establecer el controlador del mapa.
void _mapaCreado(GoogleMapController controlador) {
  _controlador.complete((controlador));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _marcadores,
            myLocationEnabled: true,
            onMapCreated: _mapaCreado,
            initialCameraPosition: _posicionInicial,
          ),
          contenedoresRestaurante(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _desplazarMapa(40.7128, -74.0060);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//Método que desplaza el mapa a una locación exacta (A través de la latitud y longitud)
Future<void> _desplazarMapa(double lat, double long) async {
  //Creamos un controlador
  GoogleMapController controlador = await _controlador.future;
  //Ejecutamos su método 'animateCamera', actualizando la camara con una nueva lat y long, y con un zoom.
  controlador
      .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));

  //TODO: AÑADIR MARCADORES A LAS POS DE LOS NEGOCIOS
/*
  setState(() {
    addMarcador(
        'Nueva York', lat, long, 'Nueva York', 'Bienvenido al invierno');
  });*/
}

//Método que se encarga de añadir marcadores a nuestro set.
void addMarcador(
    String id, double lat, double long, String nombre, String descripcion) {
  //Añade el con un ID, una posicion, y una ventana de información.
  _marcadores.add(Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: nombre, snippet: descripcion)));
}

//Widget que posee la lista de los contenedores de cada restaurante.
Widget contenedoresRestaurante() {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //TODO: Crear una lista formal de tarjetas restaurante dinámica
          //TODO: Al crear una tarjeta, deberemois generar el método para crear su marcador.
          SizedBox(
            width: 10.0,
          ),
          tarjetaRestaurante('Tacos Lalo', '2.5', '200 m', 21.0, 12.0),
          SizedBox(
            width: 10.0,
          ),
          tarjetaRestaurante('Carnitas Lupe', '5.0', '10 m', 32.0, 21.0),
        ],
      ),
    ),
  );
}

//Widget que posee las propiedades de cada restaurante.
Widget tarjetaRestaurante(String nombre, String estrellas, String distancia,
    double lat, double long) {
  //Al darle click, ejecutará la función 'desplazarMapa' con la pos del restaurante.
  return GestureDetector(
    onTap: () {
      _desplazarMapa(lat, long);
    },
    child: Container(
      child: Material(
        color: Colors.white,
        elevation: 14.0,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x802196F3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: detallesContenedor(nombre, estrellas, distancia),
              ),
            ),
            Container(
                width: 150,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image(
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1495147466023-ac5c588e2e94?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80"),
                  ),
                )),
          ],
        ),
      ),
    ),
  );
}

//Widget que posee los detalles internos de las tarjetas de cada restaurante.
Widget detallesContenedor(String nombre, String estrellas, String distancia) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Text(
          nombre,
          style: TextStyle(
              color: Color(0xffe6020a),
              fontSize: 24.0,
              fontWeight: FontWeight.bold),
        )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              estrellas,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(321) \u00B7 $distancia",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
      ),
      Container(
          child: Text(
        "Pastries \u00B7 Phoenix,AZ",
        style: TextStyle(
            color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.bold),
      )),
    ],
  );
}
