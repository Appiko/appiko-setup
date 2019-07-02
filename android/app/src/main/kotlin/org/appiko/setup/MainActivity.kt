package org.appiko.setup

import android.app.PendingIntent.getActivity
import android.content.IntentSender
import android.os.Bundle
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.common.api.ResultCallback
import com.google.android.gms.location.*
import com.google.android.gms.tasks.Task

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import com.google.android.gms.location.LocationSettingsStatusCodes
import com.google.android.gms.location.LocationSettingsResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsStates
import com.google.android.gms.common.api.GoogleApiClient









class MainActivity: FlutterActivity() {

  private val SERVICES_CHANNEL = "setup.appiko.org/services"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, SERVICES_CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "requestLocationService") {
        requestLocationService()
        result.success("")
      } else {
        result.notImplemented()
      }
    }
  }

  // https://stackoverflow.com/a/29872703/7899146
  // https://developer.android.com/training/location/change-location-settings
  private fun requestLocationService() {
    val locationRequest = LocationRequest.create()?.apply {
      interval = 10000
      fastestInterval = 5000
      priority = LocationRequest.PRIORITY_HIGH_ACCURACY
    }

    val builder = locationRequest?.let {
      LocationSettingsRequest.Builder()
              .addLocationRequest(it)
    }

    val client: SettingsClient = LocationServices.getSettingsClient(this)
    val task: Task<LocationSettingsResponse> = client.checkLocationSettings(builder?.build())

    task.addOnSuccessListener { locationSettingsResponse ->
      // All location settings are satisfied. The client can initialize
      // location requests here.
      // ...
    }

    task.addOnFailureListener { exception ->
      if (exception is ResolvableApiException){
        // Location settings are not satisfied, but this can be fixed
        // by showing the user a dialog.
        try {
          // Show the dialog by calling startResolutionForResult(),
          // and check the result in onActivityResult().
          exception.startResolutionForResult(this@MainActivity,
                  0x1)
        } catch (sendEx: IntentSender.SendIntentException) {
          // Ignore the error.
        }
      }
    }

  }
}