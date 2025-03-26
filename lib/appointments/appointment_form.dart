// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/global.dart';
import 'package:health_care_app/model/appointment.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/widgets/date_and_time_picker.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/text_input_form.dart';
import 'package:intl/intl.dart';

class AppointmentForm extends StatefulWidget {
  final Function(Appointment) onAdd;
  const AppointmentForm({super.key, required this.onAdd});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  TextEditingController date = TextEditingController();
  TextEditingController doctorType = TextEditingController();
  TextEditingController doctorName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController purpose = TextEditingController();
  final Repository repository = RepositoryImpl();
  bool isLoading = false;

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
                  width: size.width * 0.9 - 50,
                  hint: "Date",
                  controller: date,
                ),
                const SizedBox(width: 5),
                Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    boxShadow: boxShadow,
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
                      date: format.parse(date.text),
                      doctorType: doctorType.text,
                      doctorName: doctorName.text,
                      location: location.text,
                      purpose: purpose.text.isEmpty ? "" : purpose.text,
                    );
                    Appointment addedAppointment = await repository
                        .addAppointment(appointment);
                    widget.onAdd(addedAppointment);
                    setState(() => isLoading = false);
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() => isLoading = false);
                    displayErrorMotionToast(
                      'Failed to add appointment.',
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
