package com.eagleteam.knigh.schedule;

import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.eagleteam.knigh.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;


class Sortbyroll implements Comparator<Schedule> {
    // Used for sorting in ascending order of
    // roll number
    public int compare(Schedule a, Schedule b) {
        return a.getThoiGian().compareTo(b.getThoiGian());
    }
}

public class ListProvider implements RemoteViewsService.RemoteViewsFactory {

    private Context context;
    private List<Schedule> schedules;
    private List<Subjects> subjects;
    private int appWidgetId;

    public ListProvider(Context context, Intent intent) {
        this.context = context;
        appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID);
//        SharedPreferences sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE);
//        Log.e("ALL",sharedPreferences.getAll().toString());
//        Log.e("lichthi",sharedPreferences.getString("flutter.lichthi","null"));
//        Log.e("lichhoc",sharedPreferences.getString("flutter.lichhoc","null"));
//        Log.e("note",sharedPreferences.getString("flutter.note","null"));
//        String lichthi = sharedPreferences.getString("flutter.lichthi","null");
//        String lichhoc = sharedPreferences.getString("flutter.lichhoc","null");
//        String note = sharedPreferences.getString("flutter.note","null");
//        populateListItem(lichthi,lichhoc,note);
        dataChanged();
    }

    private void dataChanged() {
        SharedPreferences sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        Log.e("ALL", sharedPreferences.getAll().toString());
        Log.e("lichthi", sharedPreferences.getString("flutter.lichthi", "null"));
        Log.e("lichthilai", sharedPreferences.getString("flutter.lichthilai", "null"));
        Log.e("lichhoc", sharedPreferences.getString("flutter.lichhoc", "null"));
        Log.e("note", sharedPreferences.getString("flutter.note", "null"));
        String lichthi = sharedPreferences.getString("flutter.lichthi", "null");
        String lichthilai = sharedPreferences.getString("flutter.lichthilai", "null");
        String lichhoc = sharedPreferences.getString("flutter.lichhoc", "null");
        String note = sharedPreferences.getString("flutter.note", "null");
        populateListItem(lichthi, lichthilai, lichhoc, note);
    }

    private void populateListItem(String lichthi, String lichthilai, String lichhoc, String note) {
        if ((lichhoc.equals("null") || lichhoc.isEmpty())
                && (lichthi.equals("null") || lichthi.isEmpty())
                && (lichthilai.equals("null") || lichthilai.isEmpty())
                && (note.equals("null") || note.isEmpty())) {
            return;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, NewAppWidget.delta);
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String dateS = format.format(calendar.getTime());
        Log.e("KEY", dateS);
        schedules = new ArrayList<>();
        subjects = new ArrayList<>();
        //add subjects
        if (!(lichhoc.equals("null") || lichhoc.isEmpty()))
            subjects.addAll(getSubjects(lichhoc));
        if (!(lichthi.equals("null") || lichthi.isEmpty()))
            subjects.addAll(getSubjects(lichthi));
        if (!(lichthilai.equals("null") || lichthilai.isEmpty()))
            subjects.addAll(getSubjects(lichthilai));
        //add entries
        if (!(lichhoc.equals("null") || lichhoc.isEmpty()))
            schedules.addAll(getSchedule(lichhoc, dateS));
        if (!(lichthi.equals("null") || lichthi.isEmpty()))
            schedules.addAll(getSchedule(lichthi, dateS));
        if (!(lichthilai.equals("null") || lichthilai.isEmpty()))
            schedules.addAll(getSchedule(lichthilai, dateS));
        if (!(note.equals("null") || note.isEmpty()))
            schedules.addAll(getSchedulesByNote(note, dateS));
        if (schedules.size() > 0)
            Collections.sort(schedules, new Sortbyroll());
    }

    private List<Subjects> getSubjects(String lich) {
        List<Subjects> list = new ArrayList<>();
        try {
            JSONObject jsonObject = new JSONObject(lich);
            JSONArray jsonArray = jsonObject.getJSONArray("Subjects");
            for (int i = 0; i < jsonArray.length(); i++) {
                Subjects subjects = new Subjects();
                JSONObject jsonObject1 = jsonArray.getJSONObject(i);
                subjects.setMaMon(jsonObject1.getString("MaMon"));
                subjects.setTenMon(jsonObject1.getString("TenMon"));
                list.add(subjects);
            }
        } catch (JSONException e) {
            Log.e("add subjects", e.toString());
        }
        return list;
    }

    private String getTen(String MaMon) {
        for (int i = 0; i < subjects.size(); i++) {
            Log.e("KEY", MaMon);
            Log.e("SUBJECTS", subjects.get(i).getMaMon() + "/" + subjects.get(i).getTenMon());
            if (subjects.get(i).getMaMon().equals(MaMon)) {
                return subjects.get(i).getTenMon();
            }
        }
        return "null";
    }

    private List<Schedule> getSchedulesByNote(String lich, String key) {
        String lich1 = lich.substring(1);
        List<Schedule> list = new ArrayList<>();
        if (lich1.contains("!")) {
            String[] lich1s = lich1.split("!");
            for (String lich1ss : lich1s) {
                //
                try {
                    JSONObject jsonObject = new JSONObject(lich1ss);
                    Schedule schedule = new Schedule();
                    schedule.setDiaDiem(jsonObject.getString("DiaDiem"));
                    schedule.setGiaoVien(jsonObject.getString("GiaoVien"));
                    schedule.setHinhThuc(jsonObject.getString("HinhThuc"));
                    schedule.setLoaiLich(jsonObject.getString("LoaiLich"));
                    schedule.setMaMon(jsonObject.getString("MaMon"));
                    schedule.setTenMon(getTen(jsonObject.getString("MaMon")));
                    schedule.setNgay(jsonObject.getString("Ngay"));
                    schedule.setSoBaoDanh(jsonObject.getString("SoBaoDanh"));
                    schedule.setThoiGian(jsonObject.getString("ThoiGian"));
                    if (schedule.getNgay().equals(key))
                        list.add(schedule);

                } catch (JSONException e) {
                    Log.e("add schedule", e.toString());
                }
            }
        } else {
            //
            try {
                JSONObject jsonObject = new JSONObject(lich1);
                Schedule schedule = new Schedule();
                schedule.setDiaDiem(jsonObject.getString("DiaDiem"));
                schedule.setGiaoVien(jsonObject.getString("GiaoVien"));
                schedule.setHinhThuc(jsonObject.getString("HinhThuc"));
                schedule.setLoaiLich(jsonObject.getString("LoaiLich"));
                schedule.setMaMon(jsonObject.getString("MaMon"));
                schedule.setTenMon(getTen(jsonObject.getString("MaMon")));
                schedule.setNgay(jsonObject.getString("Ngay"));
                schedule.setSoBaoDanh(jsonObject.getString("SoBaoDanh"));
                schedule.setThoiGian(jsonObject.getString("ThoiGian"));
                if (schedule.getNgay().equals(key))
                    list.add(schedule);

            } catch (JSONException e) {
                Log.e("add schedule", e.toString());
            }
        }
        return list;
    }

    private List<Schedule> getSchedule(String lich, String key) {
        List<Schedule> list = new ArrayList<>();
        try {
            JSONObject jsonObject = new JSONObject(lich);
            JSONArray jsonArray = jsonObject.getJSONArray("Entries");
            for (int i = 0; i < jsonArray.length(); i++) {
                Schedule schedule = new Schedule();
                JSONObject jsonObject1 = jsonArray.getJSONObject(i);
                schedule.setDiaDiem(jsonObject1.getString("DiaDiem"));
                schedule.setGiaoVien(jsonObject1.getString("GiaoVien"));
                schedule.setHinhThuc(jsonObject1.getString("HinhThuc"));
                schedule.setLoaiLich(jsonObject1.getString("LoaiLich"));
                schedule.setMaMon(jsonObject1.getString("MaMon"));
                schedule.setTenMon(getTen(jsonObject1.getString("MaMon")));
                schedule.setNgay(jsonObject1.getString("Ngay"));
                schedule.setSoBaoDanh(jsonObject1.getString("SoBaoDanh"));
                schedule.setThoiGian(jsonObject1.getString("ThoiGian"));
                if (schedule.getNgay().equals(key))
                    list.add(schedule);
            }
        } catch (JSONException e) {
            Log.e("add schedule", e.toString());
        }
        return list;
    }

    @Override
    public void onCreate() {

    }

    @Override
    public void onDataSetChanged() {
        Log.e("DATA CHANGED", "ondatachanged");
        dataChanged();
    }

    @Override
    public void onDestroy() {

    }

    @Override
    public int getCount() {
        return schedules != null ? schedules.size() : 0;
    }

    private int getMua() {
        /*
         * return 1 neu la mua he
         * return 2 neu la mua dong
         * mua he bat dau tu 15/4
         * mua dong bat dau tu 15/10
         */
        int m = Calendar.getInstance().get(Calendar.MONTH)+1;
        int d = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);
        if(m==1 || m==2 || m==3 || m==11 || m==12){
            return 2;
        }
        if(m == 4){
            if(d>=15){
                return 1;
            }else{
                return 2;
            }
        }
        if(m == 10){
            if(d>=15){
                return 2;
            }else{
                return 1;
            }
        }
        return 1;
    }

    private String getThoiGian(String thoiGian) {
        String[] Time1 = {"06:30-07:20", "07:25-08:15",
                "08:25-09:15", "09:25-10:15", "10:20-11:10",
                "13:00-13:50", "13:55-14:45", "14:55-15:45",
                "15:55-16:45", "16:50-17:40", "18:15-19:05",
                "19:10-20:00"};
        String[] Time2 = {"06:45-07:35", "07:40-08:30",
                "08:40-09:30", "09:40-10:30", "10:35-11:25",
                "13:00-13:50", "13:55-14:45", "14:55-15:45",
                "15:55-16:45", "16:50-17:40", "18:15-19:05",
                "19:10-20:00"};
        int mua = getMua();
        if (thoiGian.contains(",")) {
            //co nhieu hon 1 tiet
            String[] tiets = thoiGian.split(",");
            int first = Integer.parseInt(tiets[0]);
            int last = Integer.parseInt(tiets[tiets.length - 1]);

            if (mua == 1) {
                //mua he lay lich Time1
                return "(" + Time1[first - 1].split("-")[0] + " - " + Time1[last - 1].split("-")[1] + ")";
            } else {
                return "(" + Time2[first - 1].split("-")[0] + " - " + Time2[last - 1].split("-")[1] + ")";
            }
        } else {
            //chi co 1 tiet :v
            int tiet = Integer.parseInt(thoiGian);
            if (mua == 1) {
                //mua he lay lich Time1
                return "(" + Time1[tiet - 1].split("-")[0] + " - " + Time1[tiet - 1].split("-")[1] + ")";
            } else {
                return "(" + Time2[tiet - 1].split("-")[0] + " - " + Time2[tiet - 1].split("-")[1] + ")";
            }
        }
    }

    @Override
    public RemoteViews getViewAt(int position) {
        final RemoteViews remoteView = new RemoteViews(
                context.getPackageName(), R.layout.layout_item_widget);
        Schedule schedule = schedules.get(position);
        switch (schedule.getLoaiLich()) {
            case "Note":
                remoteView.setTextViewText(R.id.tvMonHoc, "Tiêu đề: " + schedule.getMaMon());
                remoteView.setTextViewText(R.id.tvThoiGian, "Nội dung: " + schedule.getThoiGian());
                remoteView.setViewVisibility(R.id.tvDiaDiem, View.GONE);
                remoteView.setViewVisibility(R.id.tvGiaoVien, View.GONE);
                remoteView.setViewVisibility(R.id.tvHinhThuc, View.GONE);
                break;
            case "LichHoc":
                remoteView.setTextViewText(R.id.tvMonHoc, "Môn: " + schedule.getTenMon());
                remoteView.setTextViewText(R.id.tvThoiGian, "Thời gian: " + schedule.getThoiGian() + " " + getThoiGian(schedule.getThoiGian()));
                remoteView.setTextViewText(R.id.tvDiaDiem, "Địa điểm: " + schedule.getDiaDiem());
                remoteView.setTextViewText(R.id.tvGiaoVien, "Giảng viên: " + schedule.getGiaoVien());
                remoteView.setViewVisibility(R.id.tvHinhThuc, View.GONE);
                break;
            case "LichThi":
                remoteView.setTextViewText(R.id.tvMonHoc, "Môn thi: " + schedule.getTenMon());
                remoteView.setTextViewText(R.id.tvThoiGian, "Số báo danh: " + schedule.getSoBaoDanh());
                remoteView.setTextViewText(R.id.tvDiaDiem, "Thời gian: " + schedule.getThoiGian());
                remoteView.setTextViewText(R.id.tvGiaoVien, "Địa điểm: " + schedule.getDiaDiem());
                remoteView.setTextViewText(R.id.tvHinhThuc, "Hình thức: " + schedule.getHinhThuc());
                break;
        }

        return remoteView;
    }

    @Override
    public RemoteViews getLoadingView() {
        return null;
    }

    @Override
    public int getViewTypeCount() {
        return 1;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }
}
