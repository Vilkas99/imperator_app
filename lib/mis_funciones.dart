import 'mis_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

//Método que se encagra de añadir la tarjeta del negocio a vincular
void addNegocio(DetallesTarjeta detalles, tarjetasVisual, marcadores) {
  //Añadimos la tarjeta (tarjetaRestaurante) a la lista (tarjeta visual), dandole como argumento los 'detalles'
  tarjetasVisual.add(tarjetaRestaurante(detalles));
  //Añadimos un sizedboz para separarla de las demás tarjetas.
  tarjetasVisual.add(SizedBox(width: 10));
  //Ejecutamos el método para añadir un marcador.l
  addMarcador(detalles, marcadores);
}

//Método que se encarga de añadir marcadores a nuestro set.
void addMarcador(DetallesTarjeta detalles, marcadores) {
  //Añadimos un Marker a la lista de marcadores.
  marcadores.add(Marker(
      markerId: MarkerId(detalles.id),
      position: LatLng(detalles.latitud, detalles.longitud),
      infoWindow:
          InfoWindow(title: detalles.nombre, snippet: detalles.descripcion)));
}
