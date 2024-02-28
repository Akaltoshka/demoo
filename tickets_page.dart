import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:demo/pages/create_ticket.dart';
import '../main.dart';


class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Opening Ceremony tickets'),
                ),
                TicketItem(title: 'Jack', subtitle: 'A6 Row7 Column9'),
                TicketItem(title: 'Rose', subtitle: 'A6 Row7 Column9'),
                ListTile(
                  title: Text('Closing Ceremony tickets'),
                ),
                TicketItem(title: 'Jack', subtitle: 'A6 Row7 Column9'),
                TicketItem(title: 'Rose', subtitle: 'A6 Row7 Column9'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicketCreatePage()),
              );
            },
            child: Text('Create a new ticket'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pages),
            label: 'Tickets',
          ),
        ],
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          }
        },
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const TicketItem({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(subtitle),
        ],
      ),
    );
  }
}

class Ticket {
  final int id;
  final String title;
  final String description;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

class TicketDatabase {
  late Database _db;

  Future<void> open() async {
    _db = await openDatabase(
      'ticket_database.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tickets(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
    );
  }

  Future<void> insertTicket(Ticket ticket) async {
    await _db.insert(
      'tickets',
      ticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ticket>> tickets() async {
    final List<Map<String, dynamic>> maps = await _db.query('tickets');
    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }
}
