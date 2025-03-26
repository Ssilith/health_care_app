import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/services/repository.dart';
import 'package:health_care_app/services/repository_impl.dart';
import 'package:health_care_app/widgets/date_and_time_picker.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/rectangular_button.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

class IceForm extends StatefulWidget {
  final IceInfo? existingInfo;
  final Function(IceInfo) onChange;
  const IceForm({super.key, required this.onChange, this.existingInfo});

  @override
  State<IceForm> createState() => _IceFormState();
}

class _IceFormState extends State<IceForm> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController birthDate = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController bloodType = TextEditingController();
  final TextEditingController allergies = TextEditingController();
  final TextEditingController medicalConditions = TextEditingController();
  final TextEditingController medications = TextEditingController();
  final TextEditingController emergencyContactName = TextEditingController();
  final TextEditingController emergencyContactNumber = TextEditingController();
  final TextEditingController relation = TextEditingController();
  final TextEditingController insuranceProvider = TextEditingController();
  final TextEditingController insuranceNumber = TextEditingController();

  final Repository repository = RepositoryImpl();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.existingInfo != null) {
      final info = widget.existingInfo!;
      fullName.text = info.fullName;
      birthDate.text = info.birthDate;
      gender.text = info.gender;
      bloodType.text = info.bloodType ?? "";
      allergies.text = info.allergies ?? "";
      medicalConditions.text = info.medicalConditions ?? "";
      medications.text = info.medications ?? "";
      emergencyContactName.text = info.emergencyContactName ?? "";
      emergencyContactNumber.text = info.emergencyContactNumber ?? "";
      relation.text = info.relation ?? "";
      insuranceProvider.text = info.insuranceProvider ?? "";
      insuranceNumber.text = info.insuranceNumber ?? "";
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
              'assets/photos/info.svg',
              height: size.height * 0.25,
            ),
            const SizedBox(height: 10),
            const Text(
              'New ICE Info Form',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Full Name',
              controller: fullName,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInputForm(
                  width: size.width * 0.9 - 45,
                  hint: "Birth Date",
                  controller: birthDate,
                ),
                const SizedBox(width: 5),
                Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () async => await selectDate(context, birthDate),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Gender',
              controller: gender,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Blood Type',
              controller: bloodType,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Allergies',
              controller: allergies,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Medical Conditions',
              controller: medicalConditions,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Medications',
              controller: medications,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Emergency Contact Name',
              controller: emergencyContactName,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Emergency Contact Number',
              controller: emergencyContactNumber,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Relation',
              controller: relation,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Insurance Provider',
              controller: insuranceProvider,
            ),
            const SizedBox(height: 5),
            TextInputForm(
              width: size.width * 0.9,
              hint: 'Insurance Number',
              controller: insuranceNumber,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: 300,
                child: RectangularButton(
                  title: 'SUBMIT',
                  isLoading: isLoading,
                  onPressed: () async {
                    if (fullName.text.isEmpty ||
                        birthDate.text.isEmpty ||
                        gender.text.isEmpty) {
                      displayErrorMotionToast('Fill in all the data.', context);
                      return;
                    }

                    try {
                      setState(() => isLoading = true);
                      IceInfo newInfo = IceInfo(
                        id: widget.existingInfo?.id,
                        userId: widget.existingInfo?.userId,
                        fullName: fullName.text.trim(),
                        birthDate: birthDate.text.trim(),
                        gender: gender.text.trim(),
                        bloodType:
                            bloodType.text.trim().isEmpty
                                ? null
                                : bloodType.text.trim(),
                        allergies:
                            allergies.text.trim().isEmpty
                                ? null
                                : allergies.text.trim(),
                        medicalConditions:
                            medicalConditions.text.trim().isEmpty
                                ? null
                                : medicalConditions.text.trim(),
                        medications:
                            medications.text.trim().isEmpty
                                ? null
                                : medications.text.trim(),
                        emergencyContactName:
                            emergencyContactName.text.trim().isEmpty
                                ? null
                                : emergencyContactName.text.trim(),
                        emergencyContactNumber:
                            emergencyContactNumber.text.trim().isEmpty
                                ? null
                                : emergencyContactNumber.text.trim(),
                        relation:
                            relation.text.trim().isEmpty
                                ? null
                                : relation.text.trim(),
                        insuranceProvider:
                            insuranceProvider.text.trim().isEmpty
                                ? null
                                : insuranceProvider.text.trim(),
                        insuranceNumber:
                            insuranceNumber.text.trim().isEmpty
                                ? null
                                : insuranceNumber.text.trim(),
                      );

                      IceInfo changedInfo =
                          widget.existingInfo != null
                              ? await repository.editIceInfo(newInfo)
                              : await repository.addIceInfo(newInfo);
                      widget.onChange(changedInfo);
                      setState(() => isLoading = false);
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() => isLoading = false);
                      displayErrorMotionToast(
                        'Failed to  ${widget.existingInfo != null ? "edit" : "add"} info.',
                        context,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
