import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/services/supabase_service.dart';
import 'package:mac_app/src/utils/responsive.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<ScheduleEvent>> _scheduleFuture;

  DateTime selectedDate = DateTime.now();
  String viewMode = 'week'; // 'day', 'week', 'month'

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _supabaseService.getScheduleEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: FutureBuilder<List<ScheduleEvent>>(
              future: _scheduleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final events = snapshot.data ?? [];

                final padding = context.responsivePadding;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateSelector(),
                      const SizedBox(height: 24),
                      _buildScheduleGrid(events),
                      const SizedBox(height: 32),
                      _buildUpcomingEvents(events),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final padding = context.responsivePadding;
    final useMobileShell = context.useMobileShell;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: useMobileShell ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (!useMobileShell)
            const Text(
              "Schedule",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          if (!useMobileShell) const Spacer(),
          Expanded(
            child: useMobileShell
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'day', label: Text('Day')),
                        ButtonSegment(value: 'week', label: Text('Week')),
                        ButtonSegment(value: 'month', label: Text('Month')),
                      ],
                      selected: {viewMode},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() => viewMode = newSelection.first);
                      },
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'day', label: Text('Day')),
                          ButtonSegment(value: 'week', label: Text('Week')),
                          ButtonSegment(value: 'month', label: Text('Month')),
                        ],
                        selected: {viewMode},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => viewMode = newSelection.first);
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add Event"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4DA3B6),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.subtract(const Duration(days: 7));
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _getMonthYear(selectedDate),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getWeekRange(selectedDate),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.add(const Duration(days: 7));
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid(List<ScheduleEvent> events) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildWeekDayHeaders(),
          const Divider(height: 1),
          _buildTimeSlots(events),
        ],
      ),
    );
  }

  Widget _buildWeekDayHeaders() {
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              "Time",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ...List.generate(5, (index) {
            final day = weekStart.add(Duration(days: index));
            final isToday =
                day.day == DateTime.now().day &&
                day.month == DateTime.now().month;

            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isToday
                      ? const Color(0xFF4DA3B6).withOpacity(0.1)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _getDayName(day.weekday),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isToday
                            ? const Color(0xFF4DA3B6)
                            : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isToday ? const Color(0xFF4DA3B6) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(List<ScheduleEvent> events) {
    return SizedBox(
      height: 600,
      child: ListView.builder(
        itemCount: 12, // 8 AM to 8 PM
        itemBuilder: (context, index) {
          final hour = 8 + index;
          return Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Text(
                      "${hour > 12 ? hour - 12 : hour}:00 ${hour >= 12 ? 'PM' : 'AM'}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                ...List.generate(5, (dayIndex) {
                  final event = _getEventForSlot(events, hour, dayIndex);
                  return Expanded(
                    child: event != null
                        ? _buildEventCard(event)
                        : Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(ScheduleEvent event) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: event.isPrimary
            ? const Color(0xFF4DA3B6).withOpacity(0.15)
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: event.isPrimary
              ? const Color(0xFF4DA3B6)
              : Colors.blue.shade300,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            event.subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(List<ScheduleEvent> events) {
    final today = DateTime.now();
    final upcomingEvents = events
        .where(
          (e) =>
              e.startTime.isAfter(
                DateTime(today.year, today.month, today.day),
              ) &&
              e.startTime.isBefore(today.add(const Duration(days: 7))),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming This Week",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (upcomingEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No upcoming events this week."),
          )
        else
          ...upcomingEvents.map((event) => _buildUpcomingEventCard(event)),
      ],
    );
  }

  Widget _buildUpcomingEventCard(ScheduleEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4DA3B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.startTime.day.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getMonthShort(event.startTime.month),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.timeRange,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              event.isPrimary ? "Priority" : "Regular",
              style: const TextStyle(fontSize: 11),
            ),
            backgroundColor: event.isPrimary
                ? const Color(0xFF4DA3B6).withOpacity(0.2)
                : Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  ScheduleEvent? _getEventForSlot(
    List<ScheduleEvent> events,
    int hour,
    int dayIndex,
  ) {
    // Only show events for current days relative to selectedDate
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final slotDate = weekStart.add(Duration(days: dayIndex));

    for (var event in events) {
      if (event.startTime.year == slotDate.year &&
          event.startTime.month == slotDate.month &&
          event.startTime.day == slotDate.day &&
          event.startTime.hour == hour) {
        return event;
      }
    }
    return null;
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  String _getWeekRange(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 4));
    return "${weekStart.day} - ${weekEnd.day} ${_getMonthShort(weekEnd.month)}";
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
