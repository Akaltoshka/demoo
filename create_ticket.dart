import 'package:flutter/material.dart';

class TicketCreatePage extends StatefulWidget {
  @override
  _TicketCreatePageState createState() => _TicketCreatePageState();
}

class _TicketCreatePageState extends State<TicketCreatePage> {
  String _selectedCeremony = 'Opening Ceremony';
  String _name = '';
  String _seat = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Create'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selector of Ceremony:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _selectedCeremony,
              onChanged: (String? value) {
                setState(() {
                  _selectedCeremony = value!;
                });
              },
              items: <String>['Opening Ceremony', 'Closing Ceremony']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Input your name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Input Seat name',
                hintText: 'Ex: A6 Row7 Column9',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _seat = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Здесь вы можете добавить логику для создания нового билета
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
