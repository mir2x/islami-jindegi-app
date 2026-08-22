package com.islami_jindegi.native_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray

class PrayerScheduleWidget : AppWidgetProvider() {
  override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
    ids.forEach { id -> updateSchedule(context, manager, id) }
    requestDataRefreshIfStale(context)
  }
}

private fun updateSchedule(context: Context, manager: AppWidgetManager, id: Int) {
  val data = HomeWidgetPlugin.getData(context)
  val theme = data.getString("theme", "classic") ?: "classic"
  val (text, accent, background) = when (theme) {
    "light" -> Triple(R.color.light_text, R.color.light_accent, R.drawable.widget_light_background)
    "dark" -> Triple(R.color.dark_text, R.color.dark_accent, R.drawable.widget_dark_background)
    else -> Triple(R.color.classic_text, R.color.classic_accent, R.drawable.widget_classic_background)
  }
  val textColor = ContextCompat.getColor(context, text)
  val accentColor = ContextCompat.getColor(context, accent)
  val ratio = getRatio(context)
  val hijri = data.getString("hijriDate", "") ?: ""
  val sunrise = data.getString("sunrise", "") ?: ""
  val current = data.getString("currentPrayer", "") ?: ""
  val schedule = runCatching { JSONArray(data.getString("prayerSchedule", "[]")) }.getOrDefault(JSONArray())
  val ids = intArrayOf(R.id.schedule0, R.id.schedule1, R.id.schedule2, R.id.schedule3, R.id.schedule4)
  val views = RemoteViews(context.packageName, R.layout.prayer_schedule_widget).apply {
    setInt(R.id.prayer_schedule_container, "setBackgroundResource", background)
    setImageViewBitmap(R.id.scheduleHijriDate, getFontBitmap(context, hijri, textColor, ratio, 15f))
    setImageViewBitmap(R.id.scheduleSunrise, getFontBitmap(context, sunrise, accentColor, ratio, 11f))
    ids.forEachIndexed { index, viewId ->
      val item = if (index < schedule.length()) schedule.optJSONObject(index) else null
      // The full localized names (for example, "যোহর, যাওয়াল") make
      // individual columns scale down. Schedule cards always use the short
      // labels so every prayer name has the same visual size.
      val title = prayerTitles[index]
      val time: String = item?.optString("time").takeUnless { it.isNullOrBlank() }
        ?: data.getString("schedule${index}Time", "--:--")
        ?: "--:--"
      val color = if (current.contains(title) && title.isNotEmpty()) accentColor else textColor
      setImageViewBitmap(viewId, getTwoLineFontBitmap(context, title, time, color, ratio, 13f))
    }
    setImageViewBitmap(
      R.id.scheduleRemainingLabel,
      getFontBitmap(context, countdownLabel(data, " বাকি:"), accentColor, ratio, 13f),
    )
    val remainingMillis = remainingCountdownMillis(data)
    setChronometer(R.id.scheduleRemaining, SystemClock.elapsedRealtime() + remainingMillis, null, remainingMillis > 0)
    setChronometerCountDown(R.id.scheduleRemaining, remainingMillis > 0)
    setTextColor(R.id.scheduleRemaining, accentColor)
    setOnClickPendingIntent(R.id.prayer_schedule_container, openLink(context, "/namaz-times"))
  }
  manager.updateAppWidget(id, views)
}

private val prayerTitles = arrayOf("ফজর", "যোহর", "আসর", "মাগরিব", "ইশা")
