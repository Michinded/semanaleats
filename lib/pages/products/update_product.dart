import 'package:flutter/material.dart';
import 'package:semanaleats/providers/product_provider.dart';
import 'package:intl/intl.dart';

class UpdateProductPage extends StatefulWidget {
  final int productId;

  UpdateProductPage({required this.productId});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _updateDateController = TextEditingController();
  TextEditingController _creationDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar los datos del producto actual
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    // Obtener el producto actual usando el ID
    Producto product = await ProductoProvider().getProductById(widget.productId);

    // Actualizar los controladores con los valores del producto
    _nameController.text = product.nombre;
    _quantityController.text = product.cantidad.toString();
    _updateDateController.text = product.fechaActualizacion;
    _creationDateController.text = product.fechaCreacion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              //Mostar la cantidad de productos
              Text('Cantidad de productos'),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _quantityController,
                enabled: true,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la cantidad de productos';
                  }
                  return null;
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decreaseQuantity,
                    color: Colors.red,
                    iconSize: 60,
                    icon: Icon(Icons.remove),
                  ),
                  SizedBox(width: 10),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: _increaseQuantity,
                    color: Colors.green,
                    iconSize: 60,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _increaseQuantity() {
    int currentQuantity = int.parse(_quantityController.text);
    _quantityController.text = (currentQuantity + 1).toString();
  }

  void _decreaseQuantity() {
    int currentQuantity = int.parse(_quantityController.text);
    if (currentQuantity > 0) {
      _quantityController.text = (currentQuantity - 1).toString();
    }
  }


  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Actualizar la fecha de actualización
      _updateDateController.text = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
      // Crear un objeto Producto con los datos actualizados
      Producto updatedProduct = Producto(
        id: widget.productId,
        nombre: _nameController.text,
        cantidad: int.parse(_quantityController.text),
        fechaCreacion: _creationDateController.text, // Mantener la fecha de creación sin cambios
        fechaActualizacion: _updateDateController.text,
      );

      // Actualizar el producto en la base de datos
      await ProductoProvider().updateProducto(updatedProduct);

      // Volver a la pantalla anterior
      Navigator.pop(context);
    }
  }
}
