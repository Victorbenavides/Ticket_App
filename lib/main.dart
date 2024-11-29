import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(TicketApp());
}

class TicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Cobro de Tickets',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.blue, fontSize: 21),
          bodyLarge: TextStyle(color: Color.fromARGB(255, 248, 245, 245)), 
          bodySmall: TextStyle(color: Color.fromARGB(108, 7, 201, 226), fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      home: TicketHomePage(),
    );
  }
}

class TicketHomePage extends StatefulWidget {
  @override
  _TicketHomePageState createState() => _TicketHomePageState();
}

class _TicketHomePageState extends State<TicketHomePage> {
  final List<Map<String, dynamic>> _records = [];
  int _totalChildren = 0;
  int _totalAdults = 0;
  int _totalRevenue = 0;

  int children = 0;
  int adults = 0;
  int amountPaid = 0;
  int total = 0;
  int change = 0;
  void _addRecord(int children, int adults, int amountPaid, int change) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    setState(() {
      _records.add({
        'date': formattedDate,
        'children': children,
        'adults': adults,
        'amountPaid': amountPaid,
        'change': change,
        'total': children * 15 + adults * 30,
      });
      _totalChildren += children;
      _totalAdults += adults;
      _totalRevenue += children * 15 + adults * 30;
    });
  }

  void _removeRecord(int index) {
    setState(() {
      final record = _records[index];
      _totalChildren -= record['children'] as int;
      _totalAdults -= record['adults'] as int;
      _totalRevenue -= record['total'] as int;
      _records.removeAt(index);
    });
  }

  void _removeChildFromRecord(int index) {
    setState(() {
      final record = _records[index];
      if (record['children'] > 0) {
        record['children']--;
        _totalChildren--;
        record['total'] -= 15;
        _totalRevenue -= 15;
      }
    });
  }

  void _removeAdultFromRecord(int index) {
    setState(() {
      final record = _records[index];
      if (record['adults'] > 0) {
        record['adults']--;
        _totalAdults--;
        record['total'] -= 30;
        _totalRevenue -= 30;
      }
    });
  }

  void _removeAllRecords() {
    setState(() {
      _records.clear();
      _totalChildren = 0;
      _totalAdults = 0;
      _totalRevenue = 0;
    });
  }

  void _showAddRecordDialog() {
    children = 0;
    adults = 0;
    amountPaid = 0;
    total = 0;
    change = 0;




    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo.shade900,
          title: Text(
            'Agregar Registro',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Número de niños', labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    children = int.tryParse(value) ?? 0;
                    total = children * 15 + adults * 30;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Número de adultos', labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    adults = int.tryParse(value) ?? 0;
                    total = children * 15 + adults * 30;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Continuar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showPaymentDialog();
                },
              ),
            ],
          ),
        );

      },
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.indigo.shade900,
              title: Text(
                'Pago',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Total a pagar: \$${total.toString()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Monto pagado',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        amountPaid = int.tryParse(value) ?? 0;
                        change = amountPaid - total;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  if (amountPaid > 0 && amountPaid < total)
                    Text(
                      'El dinero no es suficiente.',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Mostrar Cambio'),
                    onPressed: () {
                      if (amountPaid >= total) {
                        Navigator.of(context).pop();
                        _showChangeDialog();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo.shade900,
          title: Text(
            'Cambio',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Cambio a dar: \$${change.toString()}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Finalizar'),
                onPressed: () {
                  setState(() {
                    _addRecord(children, adults, amountPaid, change);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRemoveRecordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo.shade900,
          title: Text(
            'Eliminar Registro',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _records.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> record = entry.value;
              return ListTile(
                title: Text(
                  'Registro ${index + 1} - ${record['date']}',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Niños: ${record['children']}, Adultos: ${record['adults']}, Total: \$${record['total']}',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.indigo.shade900,
                        title: Text(
                          'Opciones de Eliminación',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'Eliminar registro completo',
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                _removeRecord(index);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Eliminar un niño de este registro',
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                _removeChildFromRecord(index);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Eliminar un adulto de este registro',
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                _removeAdultFromRecord(index);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Eliminar todos los registros',
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                _removeAllRecords();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          ),
          actions:      <Widget>[
            ElevatedButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Center(
        child: Text('Sistema de Cobro de Tickets',
        style: TextStyle(fontSize: 32),
      ),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            'Costo de Tickets',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Adultos: \$30',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Niños: \$15',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 84, 243, 248),
            ),
            onPressed: _showAddRecordDialog,
            child: Text('Cobrar Tickets',
            style: TextStyle(
              fontSize: 16,
            ),),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 84, 243, 248),
            ),
            onPressed: _showRemoveRecordDialog,
            child: Text('Eliminar Registros',
            style: TextStyle(
              fontSize: 16,
            ),),
          ),
          SizedBox(height: 20),
          Text(
            'Total Recaudado: \$${_totalRevenue.toString()}',
            style: Theme.of(context).textTheme.bodyMedium, // Corregido
          ),
          SizedBox(height: 10),
          Text(
            'Total Niños: ${_totalChildren.toString()} - Total Adultos: ${_totalAdults.toString()}',
            style: Theme.of(context).textTheme.bodySmall, // Corregido
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (BuildContext context, int index) {
                final record = _records[index];
                return ListTile(
                  title: Text(
                    'Registro ${index + 1} - ${record['date']}',
                    style: TextStyle(color: Color.fromARGB(255, 3, 40, 206)),
                  ),
                  subtitle: Text(
                    'Niños: ${record['children']}, Adultos: ${record['adults']}, Total: \$${record['total']}',
                    style: TextStyle(color: Color.fromARGB(255, 3, 40, 206)),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // Abrir el enlace de GitHub
                  launch('https://github.com/Victorbenavides');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'App creada por ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Victor Benavides',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan, // Color aqua
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}