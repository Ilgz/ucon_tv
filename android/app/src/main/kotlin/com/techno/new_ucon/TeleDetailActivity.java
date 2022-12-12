package com.techno.new_ucon;

import static android.view.View.INVISIBLE;
import static android.view.View.VISIBLE;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.constraintlayout.widget.ConstraintSet;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.concurrent.TimeUnit;


public class TeleDetailActivity extends AppCompatActivity {
    private ImageButton imageButton;
    private Handler handler;
    private Runnable r;
    private boolean flag = false;
    private ConstraintLayout constt;
    private ListView list;
    private Button btt;
    private boolean flagCategory = false;
    private String[] titlesAlll, titlesPoznavat, titlesSport, titlesMusical, titlesInternational, titlesCinema, titlesNews, titlesKinder;
    private String cater;
    private String mFilePath = "http://158.181.246.154:4022/rtp/239.255.1.176:5004";
    private String one = null;
    private String two = null;
    private String three = null;
    private Handler handler2;
    private VideoView videoView;
    private TextView clockTv;
    private SharedPreferences channelsDataShared;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tele_movie_detail);
        handler = new Handler();
        // TODO Auto-generated method stub
        r = this::showInActivityDialog;
        startHandler();
        channelsDataShared = getSharedPreferences("teleJson", MODE_PRIVATE);
        handler2 = new Handler();
        createPlayer();
        cater = getIntent().getStringExtra("cater");
        initi();
        createPlayer();

        Thread t = new Thread() {
            @Override
            public void run() {
                try {
                    while (!isInterrupted()) {
                        Thread.sleep(1000);
                        runOnUiThread(() -> Clock());
                    }
                } catch (InterruptedException e) {
                }
            }
        };
        t.start();
        if (cater != null) {
            switch (cater) {
                case "efir":
                    allNamesJson(7);
                    break;
                case "kino":
                    allNamesJson(3);
                    break;
                case "news":
                    allNamesJson(2);
                    break;
                case "child":
                    allNamesJson(6);
                    break;
                case "sport":
                    allNamesJson(4);
                    break;
                case "music":
                    allNamesJson(5);
                    break;
                case "international":
                    allNamesJson(8);
                    break;
                default:
                    allNamesJson(1);
            }

        }
    }





    private void Clock() {
        long date = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        String dateString = sdf.format(date);
        clockTv = findViewById(R.id.textView20);
        clockTv.setText(dateString);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        TextView tv = findViewById(R.id.textView19);
        int KeyIf = keyCode - 7;
        if (KeyIf == 1 || KeyIf == 2 || KeyIf == 3 || KeyIf == 4 || KeyIf == 5 || KeyIf == 6 || KeyIf == 7 || KeyIf == 8 || KeyIf == 9 || KeyIf == 0) {
            handler2.removeMessages(0);
            String show = "0";
            if (one == null) {
                one = String.valueOf(KeyIf);
                show = one;
            } else if (two == null) {
                two = String.valueOf(KeyIf);
                show = one + two;
            } else if (three == null) {
                three = String.valueOf(KeyIf);
                show = one + two + three;
            }
            tv.setText(show);
            findViewById(R.id.textView19).setVisibility(VISIBLE);
            handler2.postDelayed(() -> {
                String a;
                if (two == null) {
                    a = one;
                } else if (three == null) {
                    a = one + two;
                } else {
                    a = one + two + three;
                }
                if (Integer.parseInt(a) - 1 < 220 && Integer.parseInt(a) - 1 >= 0) {
                    list.setSelection(Integer.parseInt(a) - 1);
                    playVideo();
                }
                findViewById(R.id.textView19).setVisibility(INVISIBLE);
                one = null;
                two = null;
                three = null;
            }, 3000);
        } else {
            if (keyCode == 22) {
                playVideo();
                Toast.makeText(this, "Перезапуск канала...", Toast.LENGTH_SHORT).show();
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }

    private void initi() {
        imageButton = findViewById(R.id.imageButton2);
        imageButton.setOnClickListener(v -> onBackPressed());
        constt = findViewById(R.id.category_list);
        constt.setVisibility(INVISIBLE);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        list = findViewById(R.id.list1);

        findViewById(R.id.All_category_list).setOnClickListener(v -> {
            allNamesJson(1);
            onBackPressed();
        });
        findViewById(R.id.efir_list_category).setOnClickListener(v -> {
            allNamesJson(7);
            onBackPressed();
        });
        findViewById(R.id.news_category_list).setOnClickListener(v -> {
            allNamesJson(2);
            onBackPressed();

        });
        findViewById(R.id.child_list_category).setOnClickListener(v -> {
            allNamesJson(6);
            onBackPressed();

        });
        findViewById(R.id.sport_list_category).setOnClickListener(v -> {
            allNamesJson(4);

            onBackPressed();
        });
        findViewById(R.id.international_category_list).setOnClickListener(v -> {
            allNamesJson(8);
            onBackPressed();
        });
        findViewById(R.id.music_list_category).setOnClickListener(v -> {
            allNamesJson(5);

            onBackPressed();
        });
        findViewById(R.id.kin_ser_category_list).setOnClickListener(v -> {
            allNamesJson(3);
            onBackPressed();
        });
        btt = findViewById(R.id.button8);
        btt.setOnClickListener(v -> {
            constt.setVisibility(VISIBLE);
            list.setVisibility(INVISIBLE);
            btt.setVisibility(INVISIBLE);
            findViewById(R.id.imageView2).setVisibility(INVISIBLE);
            flagCategory = true;
        });
        btt.setOnFocusChangeListener((v, hasFocus) -> {
            if (hasFocus) {
                constt.setVisibility(VISIBLE);
                list.setVisibility(INVISIBLE);
                btt.setVisibility(INVISIBLE);
                findViewById(R.id.imageView2).setVisibility(INVISIBLE);
                flagCategory = true;
            }
        });

    }


    private void fullOn() {
        flag = true;
        btt.setVisibility(INVISIBLE);
        findViewById(R.id.imageView2).setVisibility(INVISIBLE);
        imageButton.setVisibility(INVISIBLE);
        list.setAlpha(0);
        videoView.setLayoutParams(new ConstraintLayout.LayoutParams(ConstraintLayout.LayoutParams.MATCH_PARENT, ConstraintLayout.LayoutParams.MATCH_PARENT));
        clockTv.setVisibility(INVISIBLE);
        findViewById(R.id.imageView11).setVisibility(INVISIBLE);
    }

    private void fullOff() {
        flag = false;
        list.setAlpha(1);
        btt.setVisibility(VISIBLE);
        imageButton.setVisibility(VISIBLE);
        findViewById(R.id.imageView2).setVisibility(VISIBLE);
        videoView.setLayoutParams(new ConstraintLayout.LayoutParams(ConstraintLayout.LayoutParams.MATCH_CONSTRAINT, ConstraintLayout.LayoutParams.MATCH_CONSTRAINT));
        ConstraintLayout constraintLayout = findViewById(R.id.pg);
        ConstraintSet constraintSet = new ConstraintSet();
        constraintSet.clone(constraintLayout);
        constraintSet.connect(R.id.player, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0);
        constraintSet.connect(R.id.player, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 200);
        constraintSet.connect(R.id.player, ConstraintSet.TOP, R.id.list1, ConstraintSet.TOP, 0);
        constraintSet.connect(R.id.player, ConstraintSet.START, R.id.list1, ConstraintSet.END, 32);
        constraintSet.applyTo(constraintLayout);
        list.requestFocus();
        clockTv.setVisibility(VISIBLE);
        findViewById(R.id.imageView11).setVisibility(VISIBLE);

    }

    @Override
    public void onBackPressed() {
        if (flagCategory) {
            constt.setVisibility(INVISIBLE);
            list.setVisibility(VISIBLE);
            btt.setVisibility(VISIBLE);
            findViewById(R.id.imageView2).setVisibility(VISIBLE);
            flagCategory = false;
            list.requestFocus();
        } else if (!flag) {
            super.onBackPressed();
        } else {
            fullOff();
        }
    }

    private void createPlayer() {
        videoView = findViewById(R.id.player);
    }

    private void playVideo() {
        for (int i = 0; i < list.getCount(); i++) {
            if (String.valueOf(list.getItemAtPosition(i)).toUpperCase().equals(cater.toUpperCase())) {
                Log.d("ListerD", String.valueOf(list.getItemAtPosition(i)));
                list.setSelection(i);
                cater = ".....";
            }
        }
        handler.removeMessages(0);
        handler.postDelayed(() -> {
            findViewById(R.id.progressBar2).setVisibility(VISIBLE);
            findViewById(R.id.imageView10).setVisibility(VISIBLE);
            videoView.setVideoURI(Uri.parse(mFilePath));
            videoView.setOnPreparedListener(mp -> {
                videoView.start();
                findViewById(R.id.progressBar2).setVisibility(INVISIBLE);
                findViewById(R.id.imageView10).setVisibility(INVISIBLE);
            });
            videoView.setOnErrorListener((mp, what, extra) -> {
                Toast.makeText(TeleDetailActivity.this, "Не удалось воспроизвести", Toast.LENGTH_SHORT).show();
                return true;
            });
        }, 3000);

    }

    private void allNamesJson(int catInt) {

        String unl;

        if (catInt == 2) {
            unl = "News";
        } else if (catInt == 3) {
            unl = "Film";
        } else if (catInt == 4) {
            unl = "Sport";
        } else if (catInt == 5) {
            unl = "Music";
        } else if (catInt == 6) {
            unl = "Child";
        } else if (catInt == 7) {
            unl = "Cognitive";
        } else if (catInt == 8) {
            unl = "International";
        } else {
            unl = "All";
        }
        JSONArray jsonArray = JresponseBoil(unl);
        if (catInt == 2) {
            titlesNews = new String[JresponseBoil("News").length()];
        } else if (catInt == 3) {
            titlesCinema = new String[JresponseBoil("Film").length()];
        } else if (catInt == 4) {
            titlesSport = new String[JresponseBoil("Sport").length()];
        } else if (catInt == 5) {
            titlesMusical = new String[JresponseBoil("Music").length()];
        } else if (catInt == 6) {
            titlesKinder = new String[JresponseBoil("Child").length()];
        } else if (catInt == 7) {
            titlesPoznavat = new String[JresponseBoil("Cognitive").length()];
        } else if (catInt == 8) {
            titlesInternational = new String[JresponseBoil("International").length()];
        } else {
            titlesAlll = new String[JresponseBoil("All").length()];
        }
        try {
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject otvet = jsonArray.getJSONObject(i);
                String dame = otvet.getString("Name");
                if (catInt == 2) {
                    titlesNews[i] = dame;
                } else if (catInt == 3) {
                    titlesCinema[i] = dame;
                } else if (catInt == 4) {
                    titlesSport[i] = dame;
                } else if (catInt == 5) {
                    titlesMusical[i] = dame;
                } else if (catInt == 6) {
                    titlesKinder[i] = dame;
                } else if (catInt == 7) {
                    titlesPoznavat[i] = dame;

                } else if (catInt == 8) {
                    titlesInternational[i] = dame;
                } else {
                    titlesAlll[i] = dame;
                }

            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        if (catInt == 2) {
            newsClick("News");
        } else if (catInt == 3) {
            newsClick("Film");
        } else if (catInt == 4) {
            newsClick("Sport");
        } else if (catInt == 5) {
            newsClick("Music");
        } else if (catInt == 6) {
            newsClick("Child");
        } else if (catInt == 7) {
            newsClick("Cognitive");
        } else if (catInt == 8) {
            newsClick("International");
        } else {
            newsClick(" ");
        }
    }

    private void newsClick(String category) {
        MyAdapter efirAdapter;
        if (category.equals("News")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesNews);
        } else if (category.equals("Film")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesCinema);
        } else if (category.equals("Sport")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesSport);
        } else if (category.equals("Music")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesMusical);
        } else if (category.equals("Child")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesKinder);
        } else if (category.equals("Cognitive")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesPoznavat);
        } else if (category.equals("International")) {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesInternational);
        } else {
            efirAdapter = new MyAdapter(TeleDetailActivity.this, titlesAlll);
        }
        list.setAdapter(efirAdapter);
        list.requestFocus();
        playVideo();
        list.setOnItemClickListener((parent, view, position, id) -> {
            if (!flag) {
                fullOn();
            } else {
                fullOff();
            }
        });
        list.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                String unl;
                if (category.equals("News")) {
                    unl = "News";
                } else if (category.equals("Film")) {
                    unl = "Film";
                } else if (category.equals("Sport")) {
                    unl = "Sport";
                } else if (category.equals("Music")) {
                    unl = "Music";
                } else if (category.equals("Child")) {
                    unl = "Child";
                } else if (category.equals("Cognitive")) {
                    unl = "Cognitive";
                } else if (category.equals("International")) {
                    unl = "International";
                } else {
                    unl = "All";
                }
                JSONArray jsonArray = JresponseBoil(unl);
                try {
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject jsonObject = jsonArray.getJSONObject(i);
                        String dink = jsonObject.getString("Link");
                        if (position == i) {
                            mFilePath = dink;
                        }
                    }
                    playVideo();
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    class MyAdapter extends ArrayAdapter<String> {
        private final String[] myTitles;
        private final Context context;

        MyAdapter(Context c, String[] titles) {
            super(c, R.layout.row, R.id.text1, titles);
            this.context = c;
            this.myTitles = titles;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            LayoutInflater layoutInflater = (LayoutInflater) getApplicationContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = layoutInflater.inflate(R.layout.row, parent, false);
            TextView images = convertView.findViewById(R.id.logo);
            TextView myTitle = convertView.findViewById(R.id.text1);
            images.setText(String.valueOf(position + 1));
            myTitle.setText(myTitles[position]);
            return convertView;
        }
    }

    @Override
    public void onUserInteraction() {
        // TODO Auto-generated method stub
        super.onUserInteraction();
        stopHandler();//stop first and then start
        startHandler();
    }

    private void stopHandler() {
        handler.removeCallbacks(r);
    }

    private void startHandler() {
        //handler.postDelayed(r, 5*60 * 1000); //for 5 minutes
        handler.postDelayed(r, 4 * 60 * 60 * 1000); //for 5 minutes
    }

    private void showInActivityDialog() {
        AlertDialog dialog = new AlertDialog.Builder(this)
                .setTitle("Отсутствие Активности")
                .setMessage("Вы не проявляли активность на протяжении 4 часов, нажмите кнопку если вы желаете продолжить просмотр.")
                .setNegativeButton("Продолжить просмотр", null)
                .create();
        dialog.setOnShowListener(new DialogInterface.OnShowListener() {
            private static final int AUTO_DISMISS_MILLIS = 60000;

            @Override
            public void onShow(final DialogInterface dialog) {
                final Button defaultButton = ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_NEGATIVE);
                final CharSequence negativeButtonText = defaultButton.getText();
                new CountDownTimer(AUTO_DISMISS_MILLIS, 100) {
                    @Override
                    public void onTick(long millisUntilFinished) {
                        defaultButton.setText(String.format(
                                Locale.getDefault(), "%s (%d)",
                                negativeButtonText,
                                TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) + 1 //add one so it never displays zero
                        ));
                    }

                    @Override
                    public void onFinish() {
                        if (((AlertDialog) dialog).isShowing()) {
                            dialog.dismiss();
                            if (flagCategory) {
                                onBackPressed();
                                onBackPressed();

                            } else if (!flag) {
                                onBackPressed();
                            } else {
                                onBackPressed();
                                onBackPressed();
                            }
                        } else {
                            startHandler();
                        }
                    }
                }.start();
            }
        });
        dialog.show();
    }

    private JSONArray JresponseBoil(String catName) {
        String dream = channelsDataShared.getString(catName, "");
        JSONArray def = null;
        try {
            def = new JSONArray(dream);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return def;
    }
}