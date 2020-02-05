import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imperator_app/MyHomePage.dart';

//Creamos una variable que almacenará el zoom que realizará el mapa al desplazarse:
final double _zoom = 10;

//Widget que posee los detalles de cada tarjeta de cada negocio.
Widget detallesContenedor(DetallesTarjeta detalles) {
  //Regresa una columna
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      //Posee un pading...
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        //Aplicado a un contenedor...
        child: Container(
            //Que posee un texto que presenta el nombre del local.
            child: Text(
          detalles.nombre,
          style: TextStyle(
              color: Color(0xffe6020a),
              fontSize: 24.0,
              fontWeight: FontWeight.bold),
        )),
      ),
      //Padding aplicado...
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        //A un contenedor...
        child: Container(
            //Que posee una fila con las estrellas a mostrar.
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              detalles.estrellas,
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
              "(321) \u00B7 ${detalles.distancia}",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
      ),
      //Contenedor que posee la dirección del lugar
      Container(
          child: Text(
        "Pastries \u00B7 Phoenix,AZ",
        style: TextStyle(
            color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.bold),
      )),
    ],
  );
}

//Widget que muestra la tarjeta del restaurante
Widget tarjetaRestaurante(DetallesTarjeta detalles) {
  //Al darle click, ejecutará la función 'desplazarMapa' con la pos del restaurante.
  return GestureDetector(
    onTap: () {
      //Al hacerle click, desplaza al usuario a la localización del negocio.
      desplazarMapa(detalles.latitud, detalles.longitud, _zoom);
    },
    child: Container(
      //Regresa un material con borde circular...
      child: Material(
        color: Colors.white,
        elevation: 14.0,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x802196F3),
        //Que posee una fila
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Con un contenedor que posee todos los detalles.
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: detallesContenedor(detalles),
              ),
            ),
            //Y otro contenedor con una imagen
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

//Clase o Widget que posee todos los contenedores (tarjetas) de ñps restaurantes.
class ContenedoresRestaurante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      //Posee un contenedor
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        //Cuyo hijo es un 'ListViewBuilder' (Una lista dinamica)
        child: ListView.builder(
          //Que se des´ñaza horizontalmente)
          scrollDirection: Axis.horizontal,
          //Y tiene items de acuerdo a la longitud de mi lista 'tarjetasVisual'
          itemCount: tarjetasVisual.length,
          itemBuilder: (BuildContext ctxt, int indice) {
            //Regresa una fila...
            return Row(
              children: <Widget>[
                //Que muestra las tarjetas...
                tarjetasVisual[indice],
              ],
            );
          },
        ),
      ),
    );
  }
}

//Clase que genera una ventana tipo 'Alerta' con texto.
class AlertaTexo extends StatelessWidget {
  //Controladores para cada uno de los inputfields.
  final controladoTextoNombre = TextEditingController();
  final controladoTextoDesc = TextEditingController();
  final controladoTextoLat = TextEditingController();
  final controladoTextoLong = TextEditingController();

  //Método asýnc que se encarga de mostrar la alerta
  mostrarDialogo(BuildContext contexto, DetallesTarjeta detalles) async {
    return showDialog(
        context: contexto,
        builder: (contexto) {
          //Regresa un alert dialog...
          return AlertDialog(
            //Con un título
            title: Text("Detalles del Negocio"),
            //Y compuesto por una columna
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Textfields para el nombre y desc del negocio
                TextField(
                  controller: controladoTextoNombre,
                  decoration: InputDecoration(hintText: "Coloca el nombre"),
                ),
                TextField(
                  controller: controladoTextoDesc,
                  decoration:
                      InputDecoration(hintText: "Coloca la descripción"),
                ),
                //Fila con textfield para la latitud y longitud
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                            controller: controladoTextoLat,
                            decoration: InputDecoration(hintText: "Latitud"))),
                    Expanded(
                        child: TextField(
                            controller: controladoTextoLong,
                            decoration: InputDecoration(hintText: "Longitud")))
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              //Boton para aceptar lo establecido por el usuario.
              FlatButton(
                child: Text("Aceptar"),
                onPressed: () {
                  //Relacionamos las propiedades de mi objeto 'detalles' con lo colocado por el usuario.
                  detalles.nombre = controladoTextoNombre.text;
                  detalles.descripcion = controladoTextoDesc.text;
                  detalles.latitud = double.parse(controladoTextoLat.text);
                  detalles.longitud = double.parse(controladoTextoLong.text);
                  //Cierra la ventana de diálogo.
                  Navigator.of(contexto).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print("ME CONSTRUYEN, YESS");
    DetallesTarjeta prueba;
    return mostrarDialogo(context, prueba);
  }
}

//Widget que posee las propiedades de cada restaurante.

class DetallesTarjeta {
  String nombre;
  String estrellas;
  double distancia;
  String urlImagen;
  double latitud;
  double longitud;
  String descripcion;
  String id;

  DetallesTarjeta(
      {this.nombre: "",
      this.estrellas: "",
      this.distancia: 0.0,
      this.urlImagen: "",
      this.latitud: 0.0,
      this.longitud: 0.0,
      this.descripcion: "",
      this.id: ""});

  void setNombre(String valor) {
    nombre = valor;
  }
}

//Widget que posee los detalles internos de las tarjetas de cada restaurante.
