import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/utils/colors.dart';
import 'package:qr_scanner/widgets/button_widget.dart';
import 'package:qr_scanner/widgets/text_widget.dart';
import 'package:qr_scanner/widgets/textfield_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io' as io;

import 'package:widgets_to_image/widgets_to_image.dart';

import '../services/add_rides.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final name = TextEditingController();

  var _dropValue = 0;
  int persons = 1;

  String ride = 'Ride 1';

  List rides = [
    'Ride 1',
    'Ride 2',
    'Ride 3',
    'Ride 4',
    'Ride 5',
  ];

  int fee = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextRegular(
          text: 'AMUSEMENT PARK TICKETING SYSTEM',
          fontSize: 18,
          color: primary!,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          child: SizedBox(
            width: 750,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextBold(
                      text: 'Ticket Generation', fontSize: 42, color: primary!),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Form(
                          onChanged: () {
                            setState(() {});
                          },
                          child: TextFieldWidget(
                            label: 'Name of Customer',
                            controller: name,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextRegular(
                                  text: 'Number of Persons',
                                  fontSize: 12,
                                  color: Colors.black),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (persons > 1) {
                                        setState(() {
                                          persons--;
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextBold(
                                    text: persons.toString(),
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        persons++;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextRegular(
                                text: 'Type of Ride',
                                fontSize: 12,
                                color: Colors.black),
                            const SizedBox(
                              height: 5,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Rides List')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return const Center(child: Text('Error'));
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.black,
                                      )),
                                    );
                                  }

                                  final data = snapshot.requireData;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    ride = data.docs.first['name'];
                                    fee = int.parse(data.docs.first['fee']);
                                  });
                                  return Container(
                                    width: 300,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          focusColor: Colors.white,
                                          value: _dropValue,
                                          underline: const SizedBox(),
                                          items: [
                                            for (int i = 0;
                                                i < data.docs.length;
                                                i++)
                                              DropdownMenuItem(
                                                onTap: () {
                                                  setState(() {
                                                    ride = data.docs[i]['name'];
                                                    fee = int.parse(
                                                        data.docs[i]['fee']);
                                                  });
                                                },
                                                value: i,
                                                child: TextRegular(
                                                    text:
                                                        '${data.docs[i]['name']}',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                          ],
                                          onChanged: ((value) {
                                            setState(() {
                                              _dropValue =
                                                  int.parse(value.toString());
                                            });
                                          })),
                                    ),
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextRegular(
                                  text: 'Cost of Ride',
                                  fontSize: 12,
                                  color: Colors.black),
                              const SizedBox(
                                height: 5,
                              ),
                              TextBold(
                                text: '₱$fee.00php',
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextRegular(
                            text: 'Total cost to be paid:',
                            fontSize: 12,
                            color: Colors.black),
                        const SizedBox(
                          height: 5,
                        ),
                        TextBold(
                          text: '₱${fee * persons}.00php',
                          fontSize: 32,
                          color: Colors.black,
                        ),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Divider(),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  fee == 0 || name.text == '' || persons == 0
                      ? const SizedBox()
                      : ButtonWidget(
                          fontSize: 28,
                          height: 60,
                          width: 350,
                          label: 'CONFIRM',
                          onPressed: () async {
                            AwesomeDialog(
                              width: 400,
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Ticketing Confirmation',
                              desc: 'Are you sure you want to continue?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                String docId = await addRide(
                                    name.text, persons, ride, fee * persons);
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: ((context) {
                                      return AlertDialog(
                                        title: TextBold(
                                            text: 'QR Code Preview',
                                            fontSize: 18,
                                            color: Colors.black),
                                        content: SizedBox(
                                          height: 300,
                                          width: 300,
                                          child: WidgetsToImage(
                                            controller: controller,
                                            child: QrImageView(
                                              data: docId,
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: (() async {
                                                Navigator.pop(context);
                                                final bytes =
                                                    await controller.capture();

                                                generatePdf(
                                                    name.text,
                                                    persons,
                                                    ride,
                                                    fee.toDouble(),
                                                    bytes!);

                                                setState(() {
                                                  name.clear();
                                                  persons = 1;
                                                });
                                              }),
                                              child: TextBold(
                                                  text: 'Continue',
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      );
                                    }));
                              },
                            ).show();
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  WidgetsToImageController controller = WidgetsToImageController();
// to save image bytes of widget
  Uint8List? bytes;

  void generatePdf(String name, int persons, String ride, double fee,
      Uint8List image) async {
    final pdf = pw.Document();

    String cdate1 = DateFormat("MMMM dd, yyyy").format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: const PdfPageFormat(
          72 * (72 / 25.4),
          297 * (72 / 25.4),
          marginLeft: 15,
          marginRight: 15,
        ),
        orientation: pw.PageOrientation.portrait,
        build: (context) => [
          pw.Center(
            child: pw.Image(pw.MemoryImage(image), height: 120, width: 120),
          ),
          pw.SizedBox(height: 5),
          pw.Center(
            child: pw.Text(
              style: const pw.TextStyle(fontSize: 8),
              cdate1,
            ),
          ),
          pw.Center(
            child: pw.Text('Amusement Park',
                style: const pw.TextStyle(fontSize: 14)),
          ),
          pw.SizedBox(height: 2),
          pw.Text('Customer Name: $name',
              style: const pw.TextStyle(fontSize: 8)),
          pw.Text('Number of Persons: $persons',
              style: const pw.TextStyle(fontSize: 8)),
          pw.Text('Type of Ride: $ride ($fee)',
              style: const pw.TextStyle(fontSize: 8)),
          pw.Text('Total Fee: ${fee * persons}.00php',
              style: const pw.TextStyle(fontSize: 8)),
          pw.Divider(),
          pw.SizedBox(height: 2),
          pw.Center(
            child: pw.Text('All Rights Reserved',
                style: const pw.TextStyle(fontSize: 10)),
          ),
          pw.SizedBox(height: 250, width: 250, child: pw.Center()),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    final output = await getTemporaryDirectory();
    final file = io.File("${output.path}/receipt.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
