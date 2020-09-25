import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlueToothPage extends StatefulWidget {
  @override
  _BlueToothPageState createState() => _BlueToothPageState();
}

class _BlueToothPageState extends State<BlueToothPage> {
//  BluetoothDevice device;
//  BluetoothState state;
//  BluetoothDeviceState deviceState;
  bool blueToothOpenFlag = true;

  FlutterBlue bluetoothInstance = FlutterBlue.instance;
  StreamSubscription scanSubscription;
  bool startScanFlag = false;

  Map scannedDeviceShowNamesMap = {};
  List scannedDeviceShowNamesList = [];
  List scannedDeviceShowIdsList = [];

  //初始化并监听设备状态
  @override
  void initState() {
    super.initState();
    //检查当前蓝牙的状态
    FlutterBlue.instance.state.listen((state) {
      //如果用户没有打开蓝牙则提醒用户打开蓝牙
      if (state == BluetoothState.off) {
        setState(() {
          blueToothOpenFlag = false;
        });
      } else if (state == BluetoothState.on) {
        setState(() {
          blueToothOpenFlag = true;
        });
      }
    });
  }

  //开始扫描蓝牙设备
  void scanForDevices() async {
    List tempDeviceNames;
    List tempDeviceIds;
    scanSubscription = bluetoothInstance.scan().listen((scanResult) async {
      if (scannedDeviceShowNamesMap.containsKey(scanResult.device.id)) {
        scannedDeviceShowNamesMap.remove(scanResult.device.id);
      } else {
        String deviceName = "";
        if (scanResult.device.name == null || scanResult.device.name == "") {
          deviceName = "此设备不可用";
        } else {
          deviceName = scanResult.device.name;
        }
        scannedDeviceShowNamesMap[(scanResult.device.id).toString()] =
            deviceName;
      }
      tempDeviceNames = [];
      tempDeviceIds = [];
      scannedDeviceShowNamesMap.forEach((key, value) {
        tempDeviceNames.add(value);
        tempDeviceIds.add(key);
      });
      setState(() {
        this.scannedDeviceShowNamesMap = scannedDeviceShowNamesMap;
        this.scannedDeviceShowNamesList = tempDeviceNames;
        this.scannedDeviceShowIdsList = tempDeviceIds;
      });
    });
  }

  //停止蓝牙设备的扫描
  void stopScanning() {
    bluetoothInstance.stopScan();
    scanSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter bluetooth plug test"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (scanSubscription == null) {
                bluetoothInstance.stopScan();
              } else {
                stopScanning();
              }
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 130, top: 50),
            child: blueToothOpenFlag
                ? Container(
                    child: startScanFlag
                        ? Container(
                            width: 100.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () {
                                stopScanning();
                                setState(() {
                                  this.startScanFlag = false;
                                  this.scannedDeviceShowNamesList = [];
                                  this.scannedDeviceShowIdsList = [];
                                });
                              },
                              child: Text("扫描停止"),
                            ),
                          )
                        : Container(
                            width: 100.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () {
                                scanForDevices();
                                setState(() {
                                  scannedDeviceShowNamesMap = {};
                                  this.startScanFlag = true;
                                });
                              },
                              child: Text("开始扫描"),
                            ),
                          ),
                  )
                : Container(),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 120,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: scannedDeviceShowNamesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Container(
                          height: 40,
                          child: Text(
                            scannedDeviceShowNamesList[index],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 120,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: scannedDeviceShowIdsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Container(
                          height: 40,
                          child: Text(
                            scannedDeviceShowIdsList[index],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: blueToothOpenFlag
                ? Container()
                : Container(
                    child: Text(
                      "请打开蓝牙!  " * 3,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.red, fontFamily: "Courier"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
