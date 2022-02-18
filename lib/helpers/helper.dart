import 'dart:convert';
import 'dart:io';

import 'package:bboard/models/category.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  Helper._();

  static int? parseInt(val, {int? defVal = 0}) {
    try {
      return val is int ? val : int.parse(val);
    } catch (e) {}

    return defVal;
  }

  static double? parseDouble(val, {double? defVal = 0}) {
    try {
      return val is double ? val : double.parse(val);
    } catch (e) {}

    return defVal;
  }

  static List<T> parseList<T>(data) {
    try {
      if (data != null) {
        if (data is List) return data as List<T>;
        if (data is String) {
          final val = json.decode(data);
          if (val is List) return List<T>.from(val);
        }
      }
    } catch (e) {}

    return const [];
  }

  static String numberWithSpaces(int number, {int spaceEvery = 3}) {
    String numStr = number.toString();
    String result = '';

    int spaceCount = spaceEvery;
    for (int index = numStr.length - 1; index >= 0; index--) {
      if (spaceCount == 0) {
        result += ' ';
        spaceCount = spaceEvery;
      }
      result += numStr[index];
      spaceCount--;
    }

    return result.split('').reversed.join();
  }

  static Future<String?> getDeviceId() async {
    String? deviceId;
    final DeviceInfoPlugin _plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceId = (await _plugin.androidInfo).androidId;
    } else if (Platform.isIOS) {
      deviceId = (await _plugin.iosInfo).identifierForVendor;
    }

    return deviceId;
  }

  static String getMapHtml(
      {lat = 0.0, lng = 0.0, double zoom = 15, autoInitMap = true}) {
    final userIcon =
        '<svg style="margin: 10px;" width="30" height="30" viewBox="0 0 40 53" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M0 53C0 47.6957 2.10714 42.6086 5.85786 38.8579C9.60859 35.1071 14.6957 33 20 33C25.3043 33 30.3914 35.1071 34.1421 38.8579C37.8929 42.6086 40 47.6957 40 53H0ZM20 30.5C11.7125 30.5 5 23.7875 5 15.5C5 7.2125 11.7125 0.5 20 0.5C28.2875 0.5 35 7.2125 35 15.5C35 23.7875 28.2875 30.5 20 30.5Z" fill="white"/>'
        '</svg>';
    return '''
      <header>
        <script src="https://maps.api.2gis.ru/2.0/loader.js?key=7c70a320-711f-4e72-99d6-54bccc526eab"></script>
        <style>
          * {
            box-sizing: border-box;
          }
          .marker-icon-div {
            background: #00000000;
          }
        </style>
      </header>
      <body>
        <div id="map" style="width: 100%; height: 100%;"></div>
        <script type="text/javascript">
          var map, marker, userMarker, icon, mapInitialized = false;
          let centerLat = 42.882004, centerLong = 74.582748;
          let markers = [];
  
          const toLoc = function(lat, lng) {
            centerLat = lat;
            centerLong = lng;
            map.setView([lat, lng], $zoom);
          }

          function userLocation(lat, lng) {
            if (userMarker == null)
              userMarker = DG.marker([lat, lng], {
                  icon: DG.divIcon({
                    iconSize: [70, 70],
                    html: '<div style="padding: 5px; height: 50; width: 50; background-color: #000000; border-radius: 50%; display: inline-block;">' + 
                      '<div style="height: 40; width: 40; background-color: #00FF00; border-radius: 50%; display: inline-block;"><div>$userIcon<div><div>' +
                    '</div>',
                    className: 'marker-icon-div',
                  })
                }).addTo(map).bindPopup('Я');
            else userMarker.setLatLng([lat, lng]);
          }
          
          function getCenter() { 
            window.flutter_inappwebview
              .callHandler('_callBack', map.getCenter().lat, map.getCenter().lng); 
          }
    
          function checkLoc(lat, lng) {
            if (lat == 0) lat = centerLat;
            if (lng == 0) lng = centerLong;
            return [lat, lng];
          }

          function onMarkerClick(id) {
            window.flutter_inappwebview
              .callHandler('_callBack', 'markerClick', id); 
          }

          const addMarker = function(lat, lng, popupText, id) {
            markers.push({location: [lng, lat], popup: popupText, id: id});
            if (mapInitialized) {
              window.flutter_inappwebview
              .callHandler('_callBack', popupText, lat, lng); 
              DG.marker([lng, lat], {
                  icon: DG.divIcon({
                    iconSize: [50, 70],
                    html: '<img onclick="onMarkerClick(' + id + ')" src="https://upload.wikimedia.org/wikipedia/commons/4/4e/Google-location-icon-color_icons_green_home.png" width="50" height="70">',
                    className: 'marker-icon-div'
                    // iconUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Google-location-icon-color_icons_green_home.png'
                  })
                }).addTo(map);
            }
          }
    
          function initMap() {
            DG.then(function () {
              map = DG.map('map', {
                center: checkLoc($lat, $lng),
                zoom: $zoom,
                fullscreenControl: true,
                zoomControl: false
              });
              
              icon = DG.icon({
                  iconUrl: '/svg/house.svg',
                  iconSize: [48, 48]
                });

              mapInitialized = true;
              window.flutter_inappwebview
                .callHandler('_mapInitCallBack', 'map initialized'); 
            });
          }
          ${autoInitMap ? 'initMap()' : ''}
        </script>
      </body>
    ''';
  }

  static String replaceAll(
    String str,
    List<String> replacementList,
    String replaceWith,
  ) {
    for (var s in replacementList) {
      str = str.replaceAll(s, replaceWith);
    }

    return str;
  }

  static List<Widget> showWidgetsFor(
    int id,
    List<int> list,
    List<Widget> widgets,
  ) =>
      [
        if (list.contains(id)) ...widgets,
      ];

  static TimeOfDay? timeOfDayFromString(String s) {
    try {
      final splitted = s.split(':');
      return TimeOfDay(
        hour: parseInt(splitted[0], defVal: 0)!,
        minute: parseInt(splitted[1], defVal: 0)!,
      );
    } catch (e) {}
    return null;
  }

  static String doubleDigits(val) {
    if (val < 10) return '0$val';
    return '$val';
  }

  static Color? colorFromHex(String s, {Color? defColor = Colors.grey}) {
    try {
      return Color(int.parse(s.replaceAll('#', '0xFF')));
    } catch (e) {
      return defColor;
    }
  }

  static String parseError(error, {String Function(dynamic key)? getKey}) {
    var message = error.toString();
    if (error is List) {
      message = error.map((e) {
        return parseError(e, getKey: getKey);
      }).join('\n');
    } else if (error is Map) {
      message = error.keys.map((key) {
        return (getKey?.call(key) ?? '') + parseError(error[key]);
      }).join('\n');
    }

    return message;
  }

  static unfocus() {
    return FocusManager.instance.primaryFocus?.unfocus();
  }
}
