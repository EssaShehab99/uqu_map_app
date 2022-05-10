import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/lecturer_scan_qr_attendance_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class LecturerScanQRAttendanceView extends StatelessWidget {
  const LecturerScanQRAttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold(
        "Scan Attendance", LecturerScanQRAttendanceViewBody());
  }
}

class LecturerScanQRAttendanceViewBody extends StatefulWidget {
  const LecturerScanQRAttendanceViewBody({Key? key}) : super(key: key);

  @override
  _LecturerScanQRAttendanceViewBodyState createState() =>
      _LecturerScanQRAttendanceViewBodyState();
}

class _LecturerScanQRAttendanceViewBodyState
    extends State<LecturerScanQRAttendanceViewBody> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  late LecturerScanQRAttendanceViewModel viewModel;

  @override
  initState() {
    super.initState();
    viewModel = context.read(lecturerScanQRAttendanceViewModel.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _buildQrView(context)),

        SizedBox(height: 10,),
        Consumer(
          builder: (context, watch, child) {
            AsyncValue loginState =
                watch(viewModel.markAttendanceStateProvider).state;


            return loginState.when(data: (dynamic value) {

              return ElevatedButton(
                  onPressed: () {
                    viewModel.markAttendance();
                  },
                  child: Center(
                    child: Text("Confirm Manual Attendance"),
                  ));

            }, error: (Object error, StackTrace? stackTrace) {
              return  ElevatedButton(
                  onPressed: () {
                    viewModel.markAttendance();
                  },
                  child: Center(
                    child: Text("Confirm Manual Attendance"),
                  ));
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.kPrimaryColor),
                ),
              );
            });
          },
        ),
        SizedBox(height: 10,),

        /*      Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)
                  Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                else
                  const Text('Scan a code'),


              ],
            ),
          ),
        )*/
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      Get.rawSnackbar(
        title: "Message",
        message: "Attendance Recorder",
        margin: const EdgeInsets.all(20),
        borderRadius: 25,
        backgroundColor: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
      );

      /*setState(() {
        result = scanData;
      });*/
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
