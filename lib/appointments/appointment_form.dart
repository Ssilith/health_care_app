import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/services/appointment_service.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/widgets/date_and_time_picker.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/text_input_form.dart';
import 'package:intl/intl.dart';

class AppointmentForm extends StatefulWidget {
  final Appointment? existingAppointment;
  final Function(Appointment) onChange;
  final AppointmentService? appointmentService;

  const AppointmentForm({
    super.key,
    required this.onChange,
    this.existingAppointment,
    this.appointmentService,
  });

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  TextEditingController date = TextEditingController();
  TextEditingController doctorType = TextEditingController();
  TextEditingController doctorName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController purpose = TextEditingController();

  late AppointmentService _appointmentService;
  bool isLoading = false;

  @override
  void initState() {
    _appointmentService = widget.appointmentService ?? AppointmentService();
    if (widget.existingAppointment != null) {
      final appointment = widget.existingAppointment!;
      date.text = DateFormat('yyyy-MM-dd h:mm a').format(appointment.date);
      doctorType.text = appointment.doctorType;
      doctorName.text = appointment.doctorName;
      location.text = appointment.location;
      purpose.text = appointment.purpose ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlankScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? size.height * 0.2
                      : 20,
            ),
            SvgPicture.asset(
              'assets/photos/appointment.svg',
              height: size.height * 0.25,
            ),
            const SizedBox(height: 10),
            const Text(
              'New Appointment Form',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInputForm(
                  width: size.width * 0.9 - (kIsWeb ? 40 : 48),
                  hint: "Date",
                  controller: date,
                ),
                Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () async => await selectDateTime(context, date),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Doctor Type',
              controller: doctorType,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Doctor Name',
              controller: doctorName,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Location',
              controller: location,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Purpose',
              controller: purpose,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: RectangularButton(
                title: 'SUBMIT',
                isLoading: isLoading,
                onPressed: () async {
                  if (date.text.isEmpty ||
                      doctorType.text.isEmpty ||
                      doctorName.text.isEmpty ||
                      location.text.isEmpty) {
                    displayErrorMotionToast('Fill in all the data.', context);
                    return;
                  }

                  try {
                    setState(() => isLoading = true);
                    final format = DateFormat('yyyy-MM-dd h:mm a');
                    Appointment appointment = Appointment(
                      id: widget.existingAppointment?.id,
                      userId: widget.existingAppointment?.userId,
                      date: format.parse(date.text),
                      doctorType: doctorType.text,
                      doctorName: doctorName.text,
                      location: location.text,
                      purpose: purpose.text.isEmpty ? "" : purpose.text,
                    );
                    Appointment addedAppointment =
                        widget.existingAppointment != null
                            ? await _appointmentService.editAppointment(
                              appointment,
                            )
                            : await _appointmentService.addAppointment(
                              appointment,
                            );
                    widget.onChange(addedAppointment);
                    setState(() => isLoading = false);
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() => isLoading = false);
                    displayErrorMotionToast(
                      'Failed to ${widget.existingAppointment != null ? "edit" : "add"} appointment.',
                      context,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
