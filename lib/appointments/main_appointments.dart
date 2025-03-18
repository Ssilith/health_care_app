// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:health_care_app/appointments/appointment_container.dart';
import 'package:health_care_app/appointments/appointment_form.dart';
import 'package:health_care_app/appointments/main_switch.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MainAppointments extends StatefulWidget {
  const MainAppointments({super.key});

  @override
  State<MainAppointments> createState() => _MainAppointmentsState();
}

class _MainAppointmentsState extends State<MainAppointments> {
  bool isCalendarView = true;
  DateTime selectedDay = DateTime.now();
  DateTime today = DateTime.now();
  List selectedDayAppointments = [];
  List selectedAfterDayAppointments = [];
  Map groupedAfterDayAppointments = {};
  final Repository repository = RepositoryImpl();
  List<Appointment> appointments = [];
  Future? getAppointments;

  @override
  void initState() {
    super.initState();
    getAppointments = repository.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AppointmentForm(
                      onAdd: (newAppointment) {
                        setState(() {
                          appointments.add(newAppointment);
                        });
                      },
                    )));
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: getAppointments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('An error occured. Please try again later.'));
              } else if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No transaction found.'));
              } else {
                appointments = snapshot.data;

                return SizedBox(
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 110),
                        SizedBox(
                          width: size.width * 0.9,
                          child: MainSwitch(
                            current: isCalendarView,
                            firstTitle: 'CHANGE TO CALENDAR',
                            secondTitle: 'CHANGE TO LIST',
                            firstIconData: Icons.list,
                            secondIconData: Icons.calendar_month,
                            onChanged: (value) => setState(
                              () => isCalendarView = value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        isCalendarView
                            ? buildCalendar(appointments)
                            : buildListView(appointments),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  List mapAppointmentsToDay(List<Appointment> appointments, DateTime day) {
    return appointments.where((appointment) {
      return isSameDay(appointment.date, day);
    }).toList();
  }

  List<Appointment> mapAppointmentsAfterDay(List<Appointment> appointments) {
    return appointments.where((appointment) {
      return appointment.date.isAfter(today) ||
          isSameDay(appointment.date, today);
    }).toList();
  }

  Map groupAppointmentsByDate(List<Appointment> appointments) {
    Map groupedAppointments = {};
    for (Appointment appointment in mapAppointmentsAfterDay(appointments)) {
      String appointmentDate = (appointment.date.toString()).split('T')[0];
      groupedAppointments.putIfAbsent(appointmentDate, () => []);
      groupedAppointments[appointmentDate]!.add(appointment);
    }

    return groupedAppointments;
  }

  List sortAppointmentsByDate(Map groupedAppointments) {
    return groupedAppointments.keys.toList()
      ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));
  }

  Widget buildListView(List<Appointment> appointments) {
    groupedAfterDayAppointments =
        groupAppointmentsByDate(mapAppointmentsAfterDay(appointments));
    selectedAfterDayAppointments =
        sortAppointmentsByDate(groupedAfterDayAppointments);

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: selectedAfterDayAppointments.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(selectedAfterDayAppointments[index])),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            ...groupedAfterDayAppointments[selectedAfterDayAppointments[index]]!
                .map((appointment) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppointnentContainer(
                        appointmentMap: appointment,
                        repository: repository,
                        onDelete: (appointmentId) {
                          setState(() {
                            appointments.removeWhere(
                                (element) => element.id == appointmentId);
                          });
                        },
                      ),
                    ))
                .toList(),
          ],
        );
      },
    );
  }

  Widget buildCalendar(List<Appointment> appointments) {
    selectedDayAppointments = mapAppointmentsToDay(appointments, selectedDay);
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TableCalendar(
          locale: 'en_Us',
          focusedDay: selectedDay,
          firstDay: DateTime(DateTime.now().year - 10),
          lastDay: DateTime(DateTime.now().year + 10),
          eventLoader: (day) {
            return mapAppointmentsToDay(appointments, day);
          },
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: (day, events) {
            setState(() {
              selectedDay = day;
              selectedDayAppointments = mapAppointmentsToDay(appointments, day);
            });
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableGestures: AvailableGestures.all,
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 38, 174, 108),
                      shape: BoxShape.circle),
                  width: 8.0,
                  height: 8.0,
                );
              }
              return null;
            },
          ),
        ),
        ...selectedDayAppointments
            .map((appointment) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AppointnentContainer(
                    appointmentMap: appointment,
                    repository: repository,
                    onDelete: (appointmentId) {
                      setState(() {
                        appointments.removeWhere(
                            (element) => element.id == appointmentId);
                      });
                    },
                  ),
                ))
            .toList()
      ],
    );
  }
}
