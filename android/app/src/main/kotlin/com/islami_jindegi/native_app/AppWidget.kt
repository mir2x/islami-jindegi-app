package com.islami_jindegi.native_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.graphics.Paint
import android.graphics.Typeface
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.TypedValue
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import kotlin.math.max
import kotlin.math.min

// private const val BG_ACTION = "es.antonborri.home_widget.action.BACKGROUND"
// private const val ANIM_FRAMES = 16
// private const val ANIM_FRAME_MS = 90L
// private val animHandler = Handler(Looper.getMainLooper())
// private var animRunnable: Runnable? = null

class AppWidget : AppWidgetProvider() {
  override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
    super.onUpdate(context, appWidgetManager, appWidgetIds)
    for (appWidgetId in appWidgetIds) {
      updateAppWidget(context, appWidgetManager, appWidgetId)
    }
    requestDataRefreshIfStale(context)
  }

  override fun onReceive(context: Context?, intent: Intent?) {
    super.onReceive(context, intent)
    // if (intent?.action == BG_ACTION && context != null) {
    //   startReloadAnimation(context)
    // }
  }

  override fun onEnabled(context: Context) {}

  override fun onDisabled(context: Context) {}
}

// fun startReloadAnimation(context: Context) { ... }
// fun getRotatedReloadBitmap(context: Context, angle: Float, sizePx: Int): Bitmap? { ... }

// Prayer times, sunrise/sunset and the countdown target only ever come from a
// full Dart-side refresh. A widget added to the home screen before that has
// happened - or one whose countdown has already run out - would otherwise sit
// on "--:--" and "00:00" until the next periodic background task.
//
// Ask Dart for fresh data in that case. Spinning up a background Flutter
// engine is not free, so it is throttled and skipped whenever the stored
// countdown target is still in the future.
private const val REFRESH_THROTTLE_MS = 60_000L
private var lastRefreshRequestAt = 0L

internal fun requestDataRefreshIfStale(context: Context) {
  val target = HomeWidgetPlugin.getData(context)
    .getString("countdownTarget", "")
    ?.toLongOrNull()
  if (target != null && target > System.currentTimeMillis()) return

  val now = SystemClock.elapsedRealtime()
  if (lastRefreshRequestAt != 0L && now - lastRefreshRequestAt < REFRESH_THROTTLE_MS) return
  lastRefreshRequestAt = now

  runCatching {
    HomeWidgetBackgroundIntent
      .getBroadcast(context, Uri.parse("appWidget://refresh"))
      .send()
  }
}

// The countdown label, for example "ইশা শেষ হতে বাকি:". Dart stores the prayer name
// already localized along with whether the countdown runs to the prayer's end
// or to its start; older stored data has neither, so fall back to the current
// prayer string.
internal fun countdownLabel(
  data: SharedPreferences,
  suffix: String,
): String {
  val stored = data.getString("countdownName", "") ?: ""
  val name = stored.ifBlank {
    (data.getString("currentPrayer", "") ?: "")
      .trim()
      .split(Regex("\\s+"))
      .firstOrNull()
      .orEmpty()
  }.ifBlank { "নামাজ" }

  val ending = (data.getString("countdownEnding", "1") ?: "1") != "0"
  val verb = if (ending) "শেষ" else "শুরু"
  return "$name $verb হতে$suffix"
}

// Milliseconds left on the stored countdown, clamped at zero.
internal fun remainingCountdownMillis(data: SharedPreferences): Long {
  val target = (data.getString("countdownTarget", "") ?: "").toLongOrNull() ?: return 0L
  return (target - System.currentTimeMillis()).coerceAtLeast(0L)
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
    val savedSunrise = widgetData.getString("sunrise", "") ?: ""
    val savedSunset = widgetData.getString("sunset", "") ?: ""
    val sunrise = if (savedSunrise.startsWith("Sunrise", ignoreCase = true) || savedSunrise.isBlank()) {
      "সূর্যোদয় --:--"
    } else {
      savedSunrise
    }
    val sunset = if (savedSunset.startsWith("Sunset", ignoreCase = true) || savedSunset.isBlank()) {
      "সূর্যাস্ত --:--"
    } else {
      savedSunset
    }
    val location = widgetData.getString("location", "Location")
    val currentPrayer = widgetData.getString("currentPrayer", "Current Prayer")
    val nextPrayer = widgetData.getString("nextPrayer", "Prayers")

    if (theme == "light") {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_light_background,
      )

      textColor = ContextCompat.getColor(context, R.color.light_text)
      highlightTextColor = ContextCompat.getColor(context, R.color.light_accent)
    } else if (theme == "classic") {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_classic_background,
      )

      textColor = ContextCompat.getColor(context, R.color.classic_text)
      highlightTextColor = ContextCompat.getColor(context, R.color.classic_accent)
    } else {
      setInt(
        R.id.widget_container,
        "setBackgroundResource",
        R.drawable.widget_dark_background,
      )

      textColor = ContextCompat.getColor(context, R.color.dark_text)
      highlightTextColor = ContextCompat.getColor(context, R.color.dark_accent)
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

    // setOnClickPendingIntent(R.id.reload, reloadContent(context))
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

fun getTwoLineFontBitmap(
  context: Context,
  firstLine: String,
  secondLine: String,
  color: Int,
  ratio: Float,
  fontSizeSP: Float,
): Bitmap {
  val size = ratio * convertDipToPix(context, fontSizeSP)
  val paint = Paint().apply {
    isAntiAlias = true
    typeface = Typeface.createFromAsset(context.assets, "fonts/solaimanlipi.ttf")
    this.color = color
    textSize = size
    textAlign = Paint.Align.CENTER
  }
  val width = max(paint.measureText(firstLine), paint.measureText(secondLine)).toInt() + size.toInt()
  val bitmap = Bitmap.createBitmap(max(width, 1), (size * 2.45f).toInt(), Bitmap.Config.ARGB_8888)
  val canvas = Canvas(bitmap)
  val center = bitmap.width / 2f
  canvas.drawText(firstLine, center, size, paint)
  canvas.drawText(secondLine, center, size * 2.1f, paint)
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
  return HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("appWidgetReload://reload"))
}
