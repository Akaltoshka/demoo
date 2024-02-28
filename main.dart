import 'dart:convert';
import 'package:demo/pages/tickets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: EventListPage(),
    );
  }
}
class Event {
  final List<String> eventPictures;
  final String eventId;
  final String eventTitle;
  final String eventText;
  final bool eventReadStatus;

  Event({
    required this.eventPictures,
    required this.eventId,
    required this.eventTitle,
    required this.eventText,
    required this.eventReadStatus,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventPictures: List<String>.from(json['eventPictures']),
      eventId: json['eventId'],
      eventTitle: json['eventTitle'],
      eventText: json['eventText'],
      eventReadStatus: json['eventReadStatus'],
    );
  }
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late List<Event> _events = [];
  late List<Event> _filteredEvents = [];
  late String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    String data = await rootBundle.loadString('assets/events_data.json');
    List<dynamic> jsonList = json.decode(data);
    setState(() {
      _events = jsonList.map((e) => Event.fromJson(e)).toList();
      _filteredEvents = _events;
    });
  }

  void _filterEvents(String status) {
    setState(() {
      _filter = status;
      if (status == 'All') {
        _filteredEvents = _events;
      } else {
        _filteredEvents = _events.where((event) => event.eventReadStatus == (status == 'Read')).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _filterEvents('All'),
                child: Text('All'),
              ),
              ElevatedButton(
                onPressed: () => _filterEvents('Unread'),
                child: Text('Unread'),
              ),
              ElevatedButton(
                onPressed: () => _filterEvents('Read'),
                child: Text('Read'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/${_filteredEvents[index].eventPictures.first}',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        _filteredEvents[index].eventTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        _filteredEvents[index].eventText,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketsPage()),
            );
          }
        },
      ),
    );
  }
}



