import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Handles network permission requests for iOS
class NetworkPermissionManager {
  static Future<bool> requestNetworkPermission() async {
    // Only request on iOS
    if (!Platform.isIOS) {
      return true;
    }

    try {
      // iOS 14+ requires explicit permission for local network access
      final status = await Permission.nearbyWifiDevices.request();
      
      debugPrint('📡 Network permission status: $status');
      
      // If user denied, at least they've been informed
      if (status.isDenied) {
        return false;
      }
      
      return true;
    } catch (e) {
      // If permission request fails, continue anyway
      debugPrint('⚠️ Network permission request error: $e');
      return true;
    }
  }

  /// Check if network permission is granted
  static Future<bool> isNetworkPermissionGranted() async {
    if (!Platform.isIOS) {
      return true;
    }

    try {
      final status = await Permission.nearbyWifiDevices.status;
      return status.isGranted;
    } catch (e) {
      return true;
    }
  }
}
