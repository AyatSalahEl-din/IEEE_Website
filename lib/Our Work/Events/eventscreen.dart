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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventLocationController,
                decoration: InputDecoration(labelText: 'Event Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventTimeController,
                decoration: InputDecoration(labelText: 'Event Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ticketLimitController,
                decoration: InputDecoration(labelText: 'Ticket Limit'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ticket limit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'Discount (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _discountForController,
                decoration: InputDecoration(labelText: 'Discount For'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount for';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numberOfBusesController,
                decoration: InputDecoration(labelText: 'Number of Buses'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of buses';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _seatsPerBusController,
                decoration: InputDecoration(labelText: 'Seats per Bus'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter seats per bus';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Is Online Event'),
                value: _isOnlineEvent,
                onChanged: (value) {
                  setState(() {
                    _isOnlineEvent = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addEvent();
                  }
                },
                child: Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
