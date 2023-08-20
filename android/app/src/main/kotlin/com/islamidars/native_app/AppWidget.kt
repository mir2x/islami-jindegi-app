package com.islamidars.native_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.*
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
  val themeColor3 = ContextCompat.getColor(context, R.color.theme_color_3)
  val themeColor4 = ContextCompat.getColor(context, R.color.theme_color_4)

  val views = RemoteViews(context.packageName, R.layout.app_widget).apply {
    val hijriDate = widgetData.getString("hijriDate", null)
    val bangaliDate = widgetData.getString("bangaliDate", null)
    val gregorianDate = widgetData.getString("gregorianDate", null)
    val sunriseTitle = widgetData.getString("sunriseTitle", null)
    val sunriseTime = widgetData.getString("sunriseTime", null)
    val sunsetTitle = widgetData.getString("sunsetTitle", null)
    val sunsetTime = widgetData.getString("sunsetTime", null)
    val location = widgetData.getString("location", null)
    val currentPrayerTitle = widgetData.getString("currentPrayerTitle", null)
    val currentPrayerTime = widgetData.getString("currentPrayerTime", null)
    val nextPrayer = widgetData.getString("nextPrayer", null)

    setImageViewBitmap(
      R.id.hijriDate,
      getFontBitmap(context, hijriDate
        ?: "Hijri Date", themeColor3, 18f),
    )
    setImageViewBitmap(
      R.id.bangaliDate,
      getFontBitmap(context, bangaliDate
        ?: "Bangali Date", themeColor3, 13f),
    )
    setImageViewBitmap(
      R.id.gregorianDate,
      getFontBitmap(context, gregorianDate
        ?: "Gregorian Date", themeColor3, 13f),
    )
    setImageViewBitmap(
      R.id.sunriseTitle,
      getFontBitmap(context, sunriseTitle
        ?: "Sunrise", themeColor3, 13f),
    )
    setImageViewBitmap(
      R.id.sunriseTime,
      getFontBitmap(context, sunriseTime
        ?: "", themeColor3, 13f),
    )
    setImageViewBitmap(
      R.id.sunsetTitle,
      getFontBitmap(context, sunsetTitle
        ?: "Sunset", themeColor3, 13f),
    )
    setImageViewBitmap(
      R.id.sunsetTime,
      getFontBitmap(context, sunsetTime
        ?: "", themeColor3, 13f),
    )
    setImageViewBitmap(
      R.id.location,
      getFontBitmap(context, location ?: "Location", themeColor4, 13f),
    )
    setImageViewBitmap(
      R.id.currentPrayerTitle,
      getFontBitmap(context, currentPrayerTitle
        ?: "Current Prayer", themeColor4, 18f),
    )
    setImageViewBitmap(
      R.id.currentPrayerTime,
      getFontBitmap(context, currentPrayerTime
        ?: "", themeColor4, 15f),
    )
    setImageViewBitmap(
      R.id.nextPrayer,
      getFontBitmap(context, nextPrayer
        ?: "Next Prayer", themeColor3, 14f),
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
