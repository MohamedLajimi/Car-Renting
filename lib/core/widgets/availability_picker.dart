import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AvailabilityPicker extends StatefulWidget {
  final List<DateTime> blockedDays;
  final List<DateTime> bookedDays;
  final Function(List<DateTime>) onBlockedDaysChanged;

  const AvailabilityPicker({
    super.key,
    required this.blockedDays,
    required this.bookedDays,
    required this.onBlockedDaysChanged,
  });

  @override
  State<AvailabilityPicker> createState() => _AvailabilityPickerState();
}

class _AvailabilityPickerState extends State<AvailabilityPicker> {
  late Set<DateTime> _currentBlocked;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentBlocked = widget.blockedDays.map(_normalize).toSet();
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final day = _normalize(selectedDay);

    if (widget.bookedDays.any((d) => isSameDay(d, day))) {
      SnackBarUtils.show(
        context,
        message: 'This day is booked by another customer',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      _focusedDay = focusedDay;
      if (_currentBlocked.any((d) => isSameDay(d, day))) {
        _currentBlocked.removeWhere((d) => isSameDay(d, day));
      } else {
        _currentBlocked.add(day);
      }
    });

    widget.onBlockedDaysChanged(_currentBlocked.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildLegend(),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              selectedDayPredicate: (day) =>
                  _currentBlocked.any((d) => isSameDay(d, day)),
              onDaySelected: _onDaySelected,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (widget.bookedDays.any((d) => isSameDay(d, day))) {
                    return _calendarCell(
                      day,
                      Colors.red.withValues(alpha: 0.2),
                      Colors.red,
                      Icons.lock_outline,
                    );
                  }
                  return null;
                },
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarCell(DateTime day, Color bg, Color text, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(color: text, fontWeight: FontWeight.bold),
          ),
          Positioned(bottom: 2, child: Icon(icon, size: 10, color: text)),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem("Blocked", context.colorScheme.primary),
          _legendItem("Booked", context.colorScheme.error),
          _legendItem("Available", context.colorScheme.onSurface),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
