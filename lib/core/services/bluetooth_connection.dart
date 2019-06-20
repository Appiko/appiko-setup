import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothConnectionService extends ChangeNotifier {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  var _deviceConnection;
  BluetoothDevice _device;
  bool _isConnected = false;
  bool _isConnecting = false;
  var _x;
  var _state;
  bool get isConnected => _isConnected;
  BluetoothDevice get device => _device;
  bool get isConnecting => _isConnecting;
  get state => _state;

  connect(BluetoothDevice device) async {
    _device = device;
    await _device.connect();
    _device.state.listen((s) {
      if (s == BluetoothDeviceState.connected) {
        _isConnected = true;
      }
      _isConnecting = false;
      notifyListeners();
    });
  }

  disconnect() {
    _device.disconnect();
    _isConnected = false;
    notifyListeners();
  }
}
