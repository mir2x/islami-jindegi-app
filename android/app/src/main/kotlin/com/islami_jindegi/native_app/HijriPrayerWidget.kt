package com.islami_jindegi.native_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetPlugin

class HijriPrayerWidget : AppWidgetProvider() {
  override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
    ids.forEach { id -> updateHijriPrayerWidget(context, manager, id) }
    requestDataRefreshIfStale(context)
  }
}

private fun updateHijriPrayerWidget(context: Context, manager: AppWidgetManager, id: Int) {
  val data = HomeWidgetPlugin.getData(context)
  val theme = data.getString("theme", "classic") ?: "classic"
  val hijriDate = data.getString("hijriDate", "") ?: ""
  val nextPrayerName = data.getString("nextPrayerName", "ফজর") ?: "ফজর"
  val nextPrayerTime = data.getString("nextPrayerTime", "--:--") ?: "--:--"
  val (textColor, accentColor, background) = when (theme) {
    "light" -> Triple(R.color.light_text, R.color.light_accent, R.drawable.widget_light_background)
    "dark" -> Triple(R.color.dark_text, R.color.dark_accent, R.drawable.widget_dark_background)
    else -> Triple(R.color.classic_text, R.color.classic_accent, R.drawable.widget_classic_background)
  }
  val parts = hijriDate.trim().split(Regex("\\s+"), limit = 2)
  val day = parts.firstOrNull().orEmpty()
  val monthAndYear = parts.getOrElse(1) { "" }
  val ratio = getRatio(context)
  val views = RemoteViews(context.packageName, R.layout.hijri_prayer_widget).apply {
    setInt(R.id.hijri_prayer_widget_container, "setBackgroundResource", background)
    setImageViewBitmap(R.id.hijriPrayerDay, getFontBitmap(context, day, ContextCompat.getColor(context, textColor), ratio, 30f))
    setImageViewBitmap(R.id.hijriPrayerDate, getFontBitmap(context, monthAndYear, ContextCompat.getColor(context, textColor), ratio, 16f))
    setImageViewBitmap(R.id.hijriPrayerLabel, getFontBitmap(context, countdownLabel(data, ""), ContextCompat.getColor(context, textColor), ratio, 18f))
    // A bitmap is frozen when the widget is drawn. Chronometer is a supported
    // RemoteViews view and continues ticking without reopening the app.
    val remainingMillis = remainingCountdownMillis(data)
    setChronometer(R.id.hijriPrayerCountdown, SystemClock.elapsedRealtime() + remainingMillis, null, remainingMillis > 0)
    setChronometerCountDown(R.id.hijriPrayerCountdown, remainingMillis > 0)
    setTextColor(R.id.hijriPrayerCountdown, ContextCompat.getColor(context, accentColor))
    setImageViewBitmap(R.id.hijriPrayerNextName, getFontBitmap(context, nextPrayerName, ContextCompat.getColor(context, textColor), ratio, 16f))
    setImageViewBitmap(R.id.hijriPrayerNextTime, getFontBitmap(context, nextPrayerTime, ContextCompat.getColor(context, textColor), ratio, 16f))
    setOnClickPendingIntent(R.id.hijri_prayer_widget_container, openLink(context, "/qurans"))
  }
  manager.updateAppWidget(id, views)
}

fun hijriRemainingTime(target: String): String {
  val seconds = ((target.toLongOrNull() ?: 0L) - System.currentTimeMillis()).div(1000).coerceAtLeast(0)
  return "%02d:%02d:%02d".format(seconds / 3600, seconds % 3600 / 60, seconds % 60)
    .map { character ->
      if (character in '0'..'9') {
        ('০'.code + (character - '0')).toChar()
      } else {
        character
      }
    }
    .joinToString("")
}
