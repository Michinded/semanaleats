import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registros de cuotas 3A'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text('NUM'),
                ),
                DataColumn(
                  label: Text('NOMBRE ALUMNO'),
                ),
                DataColumn(
                  label: Text('SEMANA'),
                ),
                DataColumn(label: Text('ESTADO')),
              ],
              rows: <DataRow>[
                DataRow(cells: <DataCell>[
                  DataCell(Text('1')),
                  DataCell(Text('JUAN PEREZ')),
                  DataCell(Text('PAGADO', style: TextStyle(color: Colors.green))),
                  DataCell(Text('')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('2')),
                  DataCell(Text('MARIA LOPEZ')),
                  DataCell(Text('NO PAGADO', style: TextStyle(color: Colors.red))),
                  DataCell(Text('')),
                ]),
                // Puedes agregar más filas según tus datos
              ],
            ),
          ),
        ),
      ),
    );
  }
}
