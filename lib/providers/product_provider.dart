import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductoProvider {
  BuildContext ? context;
  TextEditingController searchController = TextEditingController();
  String? searchValue;
  Database ? database;

  Future<void> init(BuildContext context) async {
    this.context = context;
      await _createDatabase();
  }

  Future<void> _createDatabase() async {
    // Obtener la ruta de la base de datos
    String databasesPath = await getDatabasesPath();
    String dbPath = '$databasesPath/semanaleats.db';
    // Abrir la base de datos
    Database database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        print('Creating table productos...');
        await db.execute(
          'CREATE TABLE productos (id INTEGER PRIMARY KEY, nombre TEXT, cantidad INTEGER, fechaCreacion TEXT, fechaActualizacion TEXT)',
        );
        print('Table productos created!');
      },
    );
    // Cerrar la base de datos
    await database.close();
  }

  Future<List<Producto>> getProductos() async {
    try{
      Database database = await openDatabase('semanaleats.db');
      List<Map<String, dynamic>> productosMapList = await database.query('productos');
      await database.close();
      return productosMapList.map((productoMap) => Producto.fromMap(productoMap)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Producto> getProductById(int id) async {
    Database database = await openDatabase('semanaleats.db');
    List<Map<String, dynamic>> productosMapList = await database.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
    await database.close();
    return Producto.fromMap(productosMapList.first);
  }

  Future<void> insertProducto(Producto producto) async {
    Database database = await openDatabase('semanaleats.db');
    await database.insert('productos', producto.toMap());
    await database.close();
  }

  Future<void> updateProducto(Producto producto) async {
    Database database = await openDatabase('semanaleats.db');
    await database.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
    await database.close();
  }

  Future<void> deleteProducto(int id) async {
    Database database = await openDatabase('semanaleats.db');
    await database.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
    await database.close();
  }


}

class Producto {
  final int? id;
  final String nombre;
  final int cantidad;
  final String fechaCreacion;
  final String fechaActualizacion;

  Producto({
    this.id,
    required this.nombre,
    required this.cantidad,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  Map<String, dynamic> toMap() {
    // Crear un mapa excluyendo el id si es null
    Map<String, dynamic> map = {
      'nombre': nombre,
      'cantidad': cantidad,
      'fechaCreacion': fechaCreacion,
      'fechaActualizacion': fechaActualizacion,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // Constructor del producto a partir de un Map
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      nombre: map['nombre'],
      cantidad: map['cantidad'],
      fechaCreacion: map['fechaCreacion'],
      fechaActualizacion: map['fechaActualizacion'],
    );
  }

  @override
  String toString() {
    return 'Producto{id: $id, nombre: $nombre, cantidad: $cantidad, fechaCreacion: $fechaCreacion, fechaActualizacion: $fechaActualizacion}';
  }
}