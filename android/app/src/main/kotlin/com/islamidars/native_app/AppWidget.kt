package com.islamidars.native_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.net.Uri
import android.util.TypedValue
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class AppWidget : AppWidgetProvider() {
  override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
    super.onUpdate(context, appWidgetManager, appWidgetIds)
    // There may be multiple widgets active, so update all of them
    for (appWidgetId in appWidgetIds) {
      updateAppWidget(context, appWidgetManager, appWidgetId)
    }
  }

  override fun onReceive(context: Context?, intent: Intent?) {
    super.onReceive(context, intent)
  }

  override fun onEnabled(context: Context) {
    // Enter relevant functionality for when the first widget is created
  }

  override fun onDisabled(context: Context) {
    // Enter relevant functionality for when the last widget is disabled
  }
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
  val widgetData = HomeWidgetPlugin.getData(context)
  var textColor: Int
  var highlightTextColor: Int

  val views = RemoteViews(context.packageName, R.layout.app_widget).apply {
    val theme = widgetData.getString("theme", "dark")
    val hijriDate = widgetData.getString("hijriDate", "Hijri Date")
    val bangaliDate = widgetData.getString("bangaliDate", "Bangali Date")
    val gregorianDate = widgetData.getString("gregorianDate", "Gregorian Date")
    val sunriseTitle = widgetData.getString("sunriseTitle", "Sunrise")
    val sunriseTime = widgetData.getString("sunriseTime", "")
    val sunsetTitle = widgetData.getString("sunsetTitle", "Sunset")
    val sunsetTime = widgetData.getString("sunsetTime", "")
    val location = widgetData.getString("location", "Location")
    val currentPrayerTitle = widgetData.getString("currentPrayerTitle", "")
    val currentPrayerTime = widgetData.getString("currentPrayerTime", "")
    val nextPrayer = widgetData.getString("nextPrayer", "Prayers")

    if (theme == "light") {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_light_background,
      )

      setInt(
        R.id.dates,
        "setBackgroundResource",
        R.drawable.container_light_background,
      )

      setInt(
        R.id.sunriseSunset,
        "setBackgroundResource",
        R.drawable.container_light_background,
      )

      textColor = ContextCompat.getColor(context, R.color.theme_color_2)
      highlightTextColor = ContextCompat.getColor(context, R.color.theme_color_8)
    } else {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_dark_background,
      )

      setInt(
        R.id.dates,
        "setBackgroundResource",
        R.drawable.container_dark_background,
      )

      setInt(
        R.id.sunriseSunset,
        "setBackgroundResource",
        R.drawable.container_dark_background,
      )

      textColor = ContextCompat.getColor(context, R.color.theme_color_3)
      highlightTextColor = ContextCompat.getColor(context, R.color.theme_color_4)
    }

    setImageViewBitmap(
      R.id.hijriDate,
      getFontBitmap(context, hijriDate, textColor, 18f),
    )
    setImageViewBitmap(
      R.id.bangaliDate,
      getFontBitmap(context, bangaliDate, textColor, 14f),
    )
    setImageViewBitmap(
      R.id.gregorianDate,
      getFontBitmap(context, gregorianDate, textColor, 14f),
    )
    setImageViewBitmap(
      R.id.sunriseTitle,
      getFontBitmap(context, sunriseTitle, textColor, 14f),
    )
    setImageViewBitmap(
      R.id.sunriseTime,
      getFontBitmap(context, sunriseTime, textColor, 14f),
    )
    setImageViewBitmap(
      R.id.sunsetTitle,
      getFontBitmap(context, sunsetTitle, textColor, 14f),
    )
    setImageViewBitmap(
      R.id.sunsetTime,
      getFontBitmap(context, sunsetTime, textColor, 14f),
    )
    setImageViewBitmap(
      R.id.location,
      getFontBitmap(context, location, highlightTextColor, 14f),
    )
    setImageViewBitmap(
      R.id.currentPrayerTitle,
      getFontBitmap(context, currentPrayerTitle, highlightTextColor, 18f),
    )
    setImageViewBitmap(
      R.id.currentPrayerTime,
      getFontBitmap(context, currentPrayerTime, highlightTextColor, 15f),
    )
    setImageViewBitmap(
      R.id.nextPrayer,
      getFontBitmap(context, nextPrayer, textColor, 14f),
    )

    setOnClickPendingIntent(R.id.quran, openLink(context, "quran"))
    setOnClickPendingIntent(R.id.books, openLink(context, "books"))
    setOnClickPendingIntent(R.id.bayans, openLink(context, "bayans"))
    setOnClickPendingIntent(R.id.malfuzat, openLink(context, "malfuzat"))
    setOnClickPendingIntent(R.id.masail, openLink(context, "masail"))
    setOnClickPendingIntent(R.id.duas, openLink(context, "duas"))
  }

  appWidgetManager.updateAppWidget(appWidgetId, views)
}

fun getFontBitmap(context: Context, text: String?, color: Int, fontSizeSP: Float): Bitmap? {
  val fontSizePX = convertDipToPix(context, fontSizeSP)
  val pad = fontSizePX / 9
  val paint = Paint()
  val typeface = Typeface.createFromAsset(context.assets, "fonts/solaimanlipi.ttf")
  paint.isAntiAlias = true
  paint.typeface = typeface
  paint.color = color
  paint.textSize = fontSizePX
  val textWidth = (paint.measureText(text) + pad * 2).toInt()
  val height = (fontSizePX / 0.75).toInt()
  val bitmap = Bitmap.createBitmap(textWidth, height, Bitmap.Config.ARGB_8888)
  val canvas = Canvas(bitmap)
  canvas.drawText(text!!, pad, fontSizePX, paint)
  return bitmap
}

fun convertDipToPix(context: Context, dip: Float): Float {
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dip, context.resources.displayMetrics)
}

fun openLink(context: Context, message: String): PendingIntent {
  return HomeWidgetLaunchIntent.getActivity(
    context,
    MainActivity::class.java,
    Uri.parse("appWidget://message?route=$message")
  )
}
