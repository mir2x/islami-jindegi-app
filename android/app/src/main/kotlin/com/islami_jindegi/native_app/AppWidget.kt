package com.islami_jindegi.native_app

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
import android.widget.ImageView
import android.view.View
import android.view.animation.AnimationUtils
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import kotlin.math.max
import kotlin.math.min
import android.util.Log

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
  val ratio = getRatio(context)

  val views = RemoteViews(context.packageName, R.layout.app_widget).apply {
    val theme = widgetData.getString("theme", "classic")
    val hijriDate = widgetData.getString("hijriDate", "Hijri Date")
    val bangaliDate = widgetData.getString("bangaliDate", "Bangali Date")
    val gregorianDate = widgetData.getString("gregorianDate", "Gregorian Date")
    val sunrise = widgetData.getString("sunrise", "Sunrise")
    val sunset = widgetData.getString("sunset", "Sunset")
    val location = widgetData.getString("location", "Location")
    val currentPrayer = widgetData.getString("currentPrayer", "Current Prayer")
    val nextPrayer = widgetData.getString("nextPrayer", "Prayers")

    if (theme == "light") {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_light_background,
      )

      textColor = ContextCompat.getColor(context, R.color.theme_color_2)
      highlightTextColor = ContextCompat.getColor(context, R.color.theme_color_8)
    } else if (theme == "classic") {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_classic_background,
      )

      textColor = ContextCompat.getColor(context, R.color.theme_color_13)
      highlightTextColor = ContextCompat.getColor(context, R.color.theme_color_2)
    } else {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_dark_background,
      )

      textColor = ContextCompat.getColor(context, R.color.theme_color_3)
      highlightTextColor = ContextCompat.getColor(context, R.color.theme_color_4)
    }

    setImageViewBitmap(
      R.id.hijriDate,
      getFontBitmap(context, hijriDate, textColor, ratio, 18f),
    )
    setImageViewBitmap(
      R.id.bangaliDate,
      getFontBitmap(context, bangaliDate, textColor, ratio, 14f),
    )
    setImageViewBitmap(
      R.id.gregorianDate,
      getFontBitmap(context, gregorianDate, textColor, ratio, 14f),
    )
    setImageViewBitmap(
      R.id.sunrise,
      getFontBitmap(context, sunrise, textColor, ratio, 14f),
    )
    setImageViewBitmap(
      R.id.sunset,
      getFontBitmap(context, sunset, textColor, ratio, 14f),
    )
    setImageViewBitmap(
      R.id.location,
      getFontBitmap(context, location, highlightTextColor, ratio, 14f),
    )
    setImageViewBitmap(
      R.id.currentPrayer,
      getFontBitmap(context, currentPrayer, highlightTextColor, ratio, 18f),
    )
    setImageViewBitmap(
      R.id.nextPrayer,
      getFontBitmap(context, nextPrayer, textColor, ratio, 14f),
    )

    setOnClickPendingIntent(R.id.reload, reloadContent(context))
    setOnClickPendingIntent(R.id.quran, openLink(context, "/qurans"))
    setOnClickPendingIntent(R.id.books, openLink(context, "/books"))
    setOnClickPendingIntent(R.id.bayans, openLink(context, "/bayans"))
    setOnClickPendingIntent(R.id.malfuzat, openLink(context, "/malfuzat"))
    setOnClickPendingIntent(R.id.masail, openLink(context, "/masail"))
    setOnClickPendingIntent(R.id.duas, openLink(context, "/duas"))
  }

  appWidgetManager.updateAppWidget(appWidgetId, views)
}

fun getFontBitmap(context: Context, text: String?, color: Int, ratio: Float, fontSizeSP: Float): Bitmap? {
  val fontSizePX = ratio * convertDipToPix(context, fontSizeSP)
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

fun getRatio(context: Context): Float {
  val metrics = context.resources.displayMetrics
  val densityRatio = metrics.density / 3.00f
  val dimensionRatio = metrics.widthPixels / 1080f

  val ratio = if (densityRatio > 1 && dimensionRatio > 1) {
    min(densityRatio, dimensionRatio)
  } else {
    max(densityRatio, dimensionRatio)
  }

  return max(ratio, 1.0f)
}

fun openLink(context: Context, message: String): PendingIntent {
  val intent = Intent(context, MainActivity::class.java)
  intent.action = "es.antonborri.home_widget.action.LAUNCH"
  intent.data = Uri.parse("appWidget://message?route=$message")

  var flags = PendingIntent.FLAG_UPDATE_CURRENT
  if (android.os.Build.VERSION.SDK_INT >= 23) {
    flags = flags or PendingIntent.FLAG_IMMUTABLE
  }

  return PendingIntent.getActivity(context, 0, intent, flags)
}

fun reloadContent(context: Context): PendingIntent {
  val intent = Intent("es.antonborri.home_widget.action.BACKGROUND")
  intent.setPackage(context.packageName)
  intent.data = Uri.parse("appWidgetReload://reload")
  
  var flags = PendingIntent.FLAG_UPDATE_CURRENT
  if (android.os.Build.VERSION.SDK_INT >= 23) {
    flags = flags or PendingIntent.FLAG_IMMUTABLE
  }

  return PendingIntent.getBroadcast(context, 0, intent, flags)
}
