import 'package:flutter/material.dart';
import 'package:semanaleats/pages/products/update_product.dart';
import 'package:semanaleats/providers/product_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ProductoProvider _controller = ProductoProvider();
  List<Producto> productos = [];

  //Se esta cargando la lista de productos
  bool cargando = true;

  String _searchText = '';

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
    // Filtra la lista según el texto de búsqueda
    List<Producto> productosFiltrados = productosFromDB.where((producto) {
      return producto.nombre.toLowerCase().contains(_searchText.toLowerCase()) ||
          producto.fechaCreacion.toLowerCase().contains(_searchText.toLowerCase()) ||
          producto.fechaActualizacion.toLowerCase().contains(_searchText.toLowerCase()) ||
          producto.cantidad.toString().contains(_searchText.toLowerCase());
    }).toList();

    setState(() {
      productos = productosFiltrados;
      cargando = false;
    });
  }

  // Callback para manejar la acción de actualizar
  void _handleUpdateAction(int productId) {
    // Navegar a la página de actualización o realizar cualquier acción necesaria
    // Puedes pasar el ID a UpdateProductPage como argumento
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(productId: productId),
      ),
    ).then((_) {
      // Lógica para recargar la lista después de actualizar
      _loadProductos();
    });
  }

  void deleteProducto(int id) async {
    //Mostrar un diálogo de confirmación
    bool confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar) {
      // Eliminar el producto
      await ProductoProvider().deleteProducto(id);
      // Actualizar la lista de productos
      _loadProductos();
    }else{
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              // Implementa la lógica para actualizar la lista de productos
              setState(() {
                cargando = true;
              });
              _loadProductos();
              setState(() {
                cargando = false;
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
            _buildProductList(context),
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
          setState(() {
            _searchText = value;
          });
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
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

                return Slidable(
                  key: const ValueKey(0),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        //flex: 2,
                        onPressed: (context) {
                          // Actualiza el producto
                          _handleUpdateAction(productos[index].id!);
                        },
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.swipe_up,
                        label: 'Actualizar',
                      ),
                      SlidableAction(
                       // flex: 2,
                        onPressed: (context) {
                          // Elimina el producto
                          deleteProducto(productos[index].id!);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Eliminar',
                      ),
                    ],
                  ),
                    child: Card(
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
                    ),
                );
              },
            );
          }
        },
      ),
    );
  }

}
