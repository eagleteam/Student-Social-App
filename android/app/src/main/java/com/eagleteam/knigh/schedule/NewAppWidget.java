package com.eagleteam.knigh.schedule;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import com.eagleteam.knigh.R;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class NewAppWidget extends AppWidgetProvider {

    public static final String ACTION_AUTO_UPDATE = "android.appwidget.action.AUTO_UPDATE";
    private static final String MyOnClick = "myOnClickTag";
    private static final String MyOnClickPre = "myOnClickTagPre";
    private static final String MyOnClickNext = "myOnClickTagNext";
    public static int delta=0;

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.e("RECEIVER", intent.getAction());
        if (ACTION_AUTO_UPDATE.equals(intent.getAction())) {
            delta = 0;
            onUpdate(context);
        } else if (MyOnClick.equals(intent.getAction())) {
            delta = 0;
            onEnabled(context);
            onUpdate(context);
        } else if (MyOnClickPre.equals(intent.getAction())) {
            delta --;
            onEnabled(context);
            onUpdate(context);
        } else if (MyOnClickNext.equals(intent.getAction())) {
            delta ++;
            onEnabled(context);
            onUpdate(context);
        } else super.onReceive(context, intent);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        Log.e("UPDATE", "update overide");
//        Log.e("UPDATE","length is "+appWidgetIds.length);
        for (int appWidgetId : appWidgetIds) {
//            Log.e("UPDATE","id is "+appWidgetIds[i]);
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DATE, delta);
            Date c = calendar.getTime();
//            Log.e("TIMECURRENT","Current time => " + c);

            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
            String formattedDate = df.format(c);
            RemoteViews remoteViews = updateWidgetListView(context,
                    appWidgetId);
            remoteViews.setOnClickPendingIntent(R.id.btnUpdate,
                    getPendingSelfIntent(context, MyOnClick));
            remoteViews.setOnClickPendingIntent(R.id.btnPre, getPendingSelfIntent(context, MyOnClickPre));
            remoteViews.setOnClickPendingIntent(R.id.btnNext, getPendingSelfIntent(context, MyOnClickNext));
            remoteViews.setTextViewText(R.id.tvTitleNgay, "Ngày: " + formattedDate);
            appWidgetManager.updateAppWidget(appWidgetId,
                    remoteViews);
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.wg_list_view);
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    private void onUpdate(Context context) {
        Log.e("UPDATE", "update");
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        ComponentName thisAppWidgetComponentName = new ComponentName(context.getPackageName(), getClass().getName());
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(thisAppWidgetComponentName);
        onUpdate(context, appWidgetManager, appWidgetIds);
    }

    private RemoteViews updateWidgetListView(Context context,
                                             int appWidgetId) {
        RemoteViews remoteViews = new RemoteViews(
                context.getPackageName(), R.layout.new_app_widget);

        Date c = Calendar.getInstance().getTime();
        Log.e("TIMECURRENT", "Current time => " + c);

        SimpleDateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
        String formattedDate = df.format(c);
        Intent svcIntent = new Intent(context, WidgetService.class);
        //passing app widget id to that RemoteViews Service
        svcIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        //setting a unique Uri to the intent
        //don't know its purpose to me right now
        svcIntent.setData(Uri.parse(
                svcIntent.toUri(Intent.URI_INTENT_SCHEME)));
        //setting adapter to listview of the widget
        remoteViews.setRemoteAdapter(appWidgetId, R.id.wg_list_view,
                svcIntent);
        //setting an empty view in case of no data
        remoteViews.setEmptyView(R.id.wg_list_view, R.id.empty_view);

        return remoteViews;
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        Util.scheduleUpdate(context);
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
        Util.clearUpdate(context);
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
//        String[] content = getContent(context);

        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.new_app_widget);
        views.setViewVisibility(R.id.empty_view, View.VISIBLE);
        views.setTextViewText(R.id.empty_view, "hien tri");
        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    private static PendingIntent getPendingSelfIntent(Context context, String action, String... content) {
        Intent intent = new Intent(context, NewAppWidget.class);
        intent.setAction(action);
        return PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }
}
