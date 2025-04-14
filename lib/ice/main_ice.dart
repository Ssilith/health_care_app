import 'package:flutter/material.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/ice/ice_container.dart';
import 'package:health_care_app/ice/ice_form.dart';
import 'package:health_care_app/model/ice_info.dart';
import 'package:health_care_app/services/ice_service.dart';

class MainIce extends StatefulWidget {
  const MainIce({super.key});

  @override
  State<MainIce> createState() => _MainIceState();
}

class _MainIceState extends State<MainIce> {
  final IceService iceService = IceService();
  List<IceInfo> infos = [];
  Future? getInfos;

  @override
  void initState() {
    super.initState();
    getInfos = iceService.getAllIceInfos();
  }

  @override
  Widget build(BuildContext context) {
    return BlankScaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => IceForm(
                    onChange: (newInfo) {
                      setState(() => infos.add(newInfo));
                    },
                  ),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder(
        future: getInfos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred. Please try again later.'),
            );
          } else {
            infos = (snapshot.data ?? []) as List<IceInfo>;
            if (infos.isEmpty) {
              return const Center(child: Text('No infos found.'));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ListView.builder(
                itemCount: infos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IceContainer(
                      info: infos[index],
                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => IceForm(
                                  existingInfo: infos[index],
                                  onChange: (info) {
                                    setState(() => infos[index] = info);
                                  },
                                ),
                          ),
                        );
                      },
                      onDelete: (noteId) {
                        setState(() {
                          infos.removeWhere((element) => element.id == noteId);
                        });
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
