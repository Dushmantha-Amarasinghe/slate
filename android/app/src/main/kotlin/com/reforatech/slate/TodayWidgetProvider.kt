package com.reforatech.slate

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.text.SpannableString
import android.text.Spanned
import android.text.style.ForegroundColorSpan
import android.text.style.RelativeSizeSpan
import android.view.View
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Today's top N tasks + a quick-add tap target (build plan Phase 7). Flutter
 * pushes plain title/id strings via [HomeWidget.saveWidgetData] whenever the
 * task list or the widgetTaskCount/widgetFilterMode settings change (see
 * lib/core/widget/home_widget_service.dart) — this provider only renders
 * whatever is currently in that SharedPreferences-backed store, it never
 * queries the database itself.
 *
 * Up to 5 fixed row views rather than a RemoteViewsService-backed
 * ListView: simpler, and matches AppSettingsTable.widgetTaskCount's max of 5
 * — a scrolling list isn't needed for a "top N" glance widget.
 */
class TodayWidgetProvider : HomeWidgetProvider() {

  companion object {
    private const val ROW_COUNT = 5
    private val ROW_IDS =
        intArrayOf(
            R.id.widget_row_0,
            R.id.widget_row_1,
            R.id.widget_row_2,
            R.id.widget_row_3,
            R.id.widget_row_4,
        )
  }

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val count = widgetData.getInt("widget_task_count", 0).coerceIn(0, ROW_COUNT)
    // 0 = open the task's detail screen, 1 = mark it complete in place —
    // see AppSettingsTable.widgetTapAction / Settings > Widget.
    val markCompleteOnTap = widgetData.getInt("widget_tap_action", 0) == 1

    appWidgetIds.forEach { widgetId ->
      val views =
          RemoteViews(context.packageName, R.layout.today_widget_layout).apply {
            val openTodayIntent =
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("slate://widget/today"),
                )
            setOnClickPendingIntent(R.id.widget_header, openTodayIntent)

            val addTaskIntent =
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("slate://widget/add-task"),
                )
            setOnClickPendingIntent(R.id.widget_add_button, addTaskIntent)

            setViewVisibility(R.id.widget_empty_state, if (count == 0) View.VISIBLE else View.GONE)

            for (i in 0 until ROW_COUNT) {
              val rowId = ROW_IDS[i]
              if (i < count) {
                val title = widgetData.getString("widget_task_title_$i", null) ?: continue
                val taskId = widgetData.getString("widget_task_id_$i", null)
                val subtaskProgress = widgetData.getString("widget_task_subtasks_$i", null)
                setTextViewText(rowId, rowLabel(context, title, markCompleteOnTap, subtaskProgress))
                setViewVisibility(rowId, View.VISIBLE)

                val rowIntent =
                    if (markCompleteOnTap && taskId != null) {
                      HomeWidgetBackgroundIntent.getBroadcast(
                          context,
                          Uri.parse("slate://widget/complete/$taskId"),
                      )
                    } else {
                      val taskUri =
                          if (taskId != null) Uri.parse("slate://widget/task/$taskId")
                          else Uri.parse("slate://widget/today")
                      HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, taskUri)
                    }
                setOnClickPendingIntent(rowId, rowIntent)
              } else {
                setViewVisibility(rowId, View.GONE)
              }
            }
          }

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  /**
   * "○ Title  2/5" (mark-complete mode) or "• Title  2/5" (open-detail
   * mode). The mark-complete circle is sized up via a span rather than
   * bumping the whole row's text size — it's meant to read as a real
   * checkbox-style tap target, not just a bigger list marker. The
   * subtask-progress suffix (when the task has a checklist) is a
   * glanceable label only: RemoteViews rows are a single tap target, so
   * there's no way to check off an individual subtask from the widget —
   * that still means opening the task.
   */
  private fun rowLabel(
      context: Context,
      title: String,
      markCompleteOnTap: Boolean,
      subtaskProgress: String?,
  ): CharSequence {
    val bullet = if (markCompleteOnTap) "○" else "•"
    val hasProgress = !subtaskProgress.isNullOrEmpty()
    val text = "$bullet  $title" + if (hasProgress) "   $subtaskProgress" else ""

    if (!markCompleteOnTap && !hasProgress) return text

    return SpannableString(text).apply {
      if (markCompleteOnTap) {
        setSpan(RelativeSizeSpan(1.5f), 0, bullet.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
      }
      if (hasProgress) {
        val progressStart = text.length - subtaskProgress!!.length
        setSpan(
            ForegroundColorSpan(ContextCompat.getColor(context, R.color.widget_text_secondary)),
            progressStart,
            text.length,
            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE,
        )
        setSpan(RelativeSizeSpan(0.85f), progressStart, text.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
      }
    }
  }
}
