import 'package:flutter/material.dart';
import 'package:semanaleats/providers/product_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ProductoProvider _controller = ProductoProvider();
  List<Producto> productos = [];


  //Ordenar de Az a Za
  bool ordenarAZ = false;
  //Ordenar por cantidad
  bool ordenarPorCantidadAscendente = false;
  //Ordenar por fecha de creación
  bool ordenarPorFechaCreacionAscendente = false;
  //Ordenar por fecha de actualización
  bool ordenarPorFechaActualizacionAscendente = false;

  //Se esta cargando la lista de productos
  bool cargando = true;

  @override
  void initState(){
    super.initState();
    // Inicializa la lista de productos
    _controller.init(context);
    _loadProductos();
  }


  Future<void> _loadProductos() async {
    // Muestra el indicador de carga
    setState(() {
      cargando = true;
    });
    // Carga la lista de productos
    List<Producto> productosFromDB = await ProductoProvider().getProductos();
    setState(() {
      productos = productosFromDB;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              // Implementa la lógica para ordenar AZ-ZA
              setState(() {
                ordenarAZ = !ordenarAZ;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Implementa la lógica para ordenar por cantidad
              setState(() {
                ordenarPorCantidadAscendente = !ordenarPorCantidadAscendente;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              // Implementa la lógica para ordenar por fecha de creación
              setState(() {
                ordenarPorFechaCreacionAscendente = !ordenarPorFechaCreacionAscendente;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              // Implementa la lógica para ordenar por fecha de actualización
              setState(() {
                ordenarPorFechaActualizacionAscendente = !ordenarPorFechaActualizacionAscendente;
              });
            },
          ),
        ],
      ),
      body: _buildBody(),

    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchField(),
            cargando ?
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ) :
            _buildProductList(),
          ],
        ),
        _floatingActionButton(),
      ],
    );
  }

  Widget _floatingActionButton() {
    return Positioned(
      bottom: 15.0,
      right: 15.0,
      child: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'Agregar Producto',
        onPressed: () {
          // Implementa la lógica para agregar un producto
          Navigator.pushNamed(context, 'create-product').then((value) {
            _loadProductos();
          });
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        // controller: searchController,
        decoration: InputDecoration(
          labelText: 'Buscar productos',
          suffixIcon: Icon(Icons.search),
          labelStyle: TextStyle(color: Colors.blue), // Color del texto flotante
          floatingLabelStyle: TextStyle(color: Colors.blue), // Color del texto flotante cuando se enfoca
          suffixIconColor: Colors.blue, // Color del icono del sufijo (en este caso, el ícono de búsqueda)
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Color del borde cuando el campo no está enfocado
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Color del borde cuando el campo está enfocado
          ),
        ),
        onChanged: (value) {
          // Implementa la lógica de búsqueda según tu necesidad
          // Puedes filtrar la lista de productos y actualizar el estado
        },
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: FutureBuilder<List<Producto>>(
        // Define el futuro que carga los productos
        future: _controller.getProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los productos'),
            );
          } else {
            // La carga de productos fue exitosa, construir la lista
            List<Producto> productos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                // Alternar el color de fondo para cada tarjeta
                Color? cardColor = index.isOdd ? Colors.blue[100] : Colors.blue[200];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: cardColor,
                  child: ListTile(
                    title: Text(productos[index].nombre, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${productos[index].cantidad}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5.0),
                        Text('Fecha de Actualización: ${productos[index].fechaActualizacion}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: Text('ID: ${productos[index].id}', style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      // Puedes agregar lógica para manejar la selección de la tarjeta
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
  /*
  Widget _buildProductList() {
    return Expanded(
      child: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          // Alternar el color de fondo para cada tarjeta
          Color? cardColor = index.isOdd ? Colors.blue[100] : Colors.blue[200];

          return Card(
            margin: EdgeInsets.all(8.0),
            color: cardColor,
            child: ListTile(
              title: Text(productos[index].nombre, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cantidad: ${productos[index].cantidad}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5.0),
                  Text('Fecha de Actualización: ${productos[index].fechaActualizacion}', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              trailing: Text('ID: ${productos[index].id}', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                // Puedes agregar lógica para manejar la selección de la tarjeta
              },
            ),
          );
        },
      ),
    );
  }*/
}
