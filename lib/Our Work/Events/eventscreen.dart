import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _eventTimeController = TextEditingController();
  final _ticketLimitController = TextEditingController();
  final _discountController = TextEditingController();
  final _discountForController = TextEditingController();
  final _numberOfBusesController = TextEditingController();
  final _seatsPerBusController = TextEditingController();
  DateTime? _selectedDate;
  bool _isOnlineEvent = false;

  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventLocationController.dispose();
    _eventTimeController.dispose();
    _ticketLimitController.dispose();
    _discountController.dispose();
    _discountForController.dispose();
    _numberOfBusesController.dispose();
    _seatsPerBusController.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .orderBy('date')
              .get();

      setState(() {
        _events =
            snapshot.docs.map((doc) {
              final data =
                  doc.data()
                      as Map<
                        String,
                        dynamic
                      >; // Explicitly cast to Map<String, dynamic>
              return {
                'id': doc.id,
                'name': data['name'] ?? 'Unnamed Event',
                'date': (data['date'] as Timestamp).toDate(),
                'location': data['location'] ?? 'No location provided',
                'time': data['time'] ?? 'No time provided',
                'isOnlineEvent': data['isOnlineEvent'] ?? false,
              };
            }).toList();
        _isLoading = false;
      });
    } catch (e) {
      _showError('Failed to fetch events: $e');
      print('Debug: Error fetching events - $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addEvent() async {
    try {
      final eventData = {
        'name': _eventNameController.text.trim(),
        'date': Timestamp.fromDate(_selectedDate!),
        'location': _eventLocationController.text.trim(),
        'time': _eventTimeController.text.trim(),
        'isOnlineEvent': _isOnlineEvent,
        'ticketLimit': int.tryParse(_ticketLimitController.text.trim()) ?? 0,
        'discount': double.tryParse(_discountController.text.trim()) ?? 0.0,
        'discountFor': _discountForController.text.trim(),
        'numberOfBuses':
            int.tryParse(_numberOfBusesController.text.trim()) ?? 0,
        'seatsPerBus': int.tryParse(_seatsPerBusController.text.trim()) ?? 0,
      };

      await FirebaseFirestore.instance.collection('events').add(eventData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
    } catch (e) {
      _showError('Failed to add event: $e');
    }
  }

  Future<void> _editEvent(String eventId) async {
    try {
      final updatedEventData = {
        'name': _eventNameController.text.trim(),
        'date': Timestamp.fromDate(_selectedDate!),
        'location': _eventLocationController.text.trim(),
        'time': _eventTimeController.text.trim(),
        'isOnlineEvent': _isOnlineEvent,
        'ticketLimit': int.tryParse(_ticketLimitController.text.trim()) ?? 0,
        'discount': double.tryParse(_discountController.text.trim()) ?? 0.0,
        'discountFor': _discountForController.text.trim(),
        'numberOfBuses':
            int.tryParse(_numberOfBusesController.text.trim()) ?? 0,
        'seatsPerBus': int.tryParse(_seatsPerBusController.text.trim()) ?? 0,
      };

      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .update(updatedEventData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );
    } catch (e) {
      _showError('Failed to update event: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Management')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      title: Text(event['name']),
                      subtitle: Text(
                        '${DateFormat('yyyy-MM-dd').format(event['date'])} at ${event['time']}',
                      ),
                      trailing:
                          event['isOnlineEvent']
                              ? const Icon(Icons.wifi, color: Colors.green)
                              : const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _addEvent();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
