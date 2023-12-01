import 'package:flutter/material.dart';
import 'package:semanaleats/providers/product_provider.dart';
import 'package:intl/intl.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Producto'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _cantidadController,
              decoration: InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _agregarProducto();
                Navigator.pop(context); // Regresar a la página anterior
              },
              child: Text('Añadir Producto'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _agregarProducto() async {
    final String nombre = _nombreController.text.trim();
    final int cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;
    String fechaActual = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    if (nombre.isNotEmpty && cantidad > 0) {
      final Producto nuevoProducto = Producto(
        nombre: nombre,
        cantidad: cantidad,
        fechaCreacion: fechaActual,
        fechaActualizacion: fechaActual,
      );

      await ProductoProvider().insertProducto(nuevoProducto);
    }
  }
}
