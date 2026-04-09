/*
 * DateAndTimeConstants.java
 *
 * Created on October 28, 2003, 11:09 AM
 */
package com.silkworm.util;

import com.maintenance.common.ConfigFileMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author walid
 */
public class DateAndTimeControl {

    public int getMinuteOfDay(String days) {
        int MinuteOfDay;
        MinuteOfDay = new Integer(days).intValue() * 60 * 24;
        return MinuteOfDay;
    }

    public int getMinuteOfHour(String hour) {
        int MinuteOfHour;
        MinuteOfHour = new Integer(hour).intValue() * 60;
        return MinuteOfHour;
    }

    public String getDaysHourMinute(int minutes) {
        HashMap time = new HashMap();
        String days = null;
        String hours = null;
        String minute = null;
        int dd = 0;
        int hh = 0;
        int mm = 0;
        String durationTime = " ";

        dd = (minutes / 60) / 24;
        days = Integer.toString(dd);
        if (days != null && !days.equals("") && !days.equals("0")) {
            if (ConfigFileMgr.getCurrentlanguage().equals("En")) {
                durationTime = durationTime + days + "dd ";
            } else {
                durationTime = durationTime + days + " &#1610;&#1608;&#1605; ";
            }
        }
        time.put("day", days);
        hh = minutes - new Integer(days) * 24 * 60;
        hours = Integer.toString((int) (hh / 60));
        if (hours != null && !hours.equals("") && !hours.equals("0")) {
            if (ConfigFileMgr.getCurrentlanguage().equals("En")) {
                durationTime = durationTime + hours + "hr ";
            } else {
                durationTime = durationTime + hours + " &#1587;&#1575;&#1593;&#1577; ";
            }
        }
        time.put("hours", hours);
        mm = minutes - new Integer(days) * 24 * 60 - new Integer(hours) * 60;
        minute = Integer.toString(mm);
        if (minute != null && !minute.equals("") && !minute.equals("0")) {
            if (ConfigFileMgr.getCurrentlanguage().equals("En")) {
                durationTime = durationTime + minute + "mm ";
            } else {
                durationTime = durationTime + minute + " &#1583;&#1602;&#1610;&#1602;&#1577; ";
            }
        }
        time.put("minute", Integer.toString(mm));

        return durationTime;

    }

    public String getDaysHourMinuteHex(int minutes) {
        HashMap time = new HashMap();
        String days = null;
        String hours = null;
        String minute = null;
        int dd = 0;
        int hh = 0;
        int mm = 0;
        String durationTime = " ";

        dd = (minutes / 60) / 24;
        days = Integer.toString(dd);
        if (days != null && !days.equals("") && !days.equals("0")) {
            if (ConfigFileMgr.getCurrentlanguage().equals("En")) {
                durationTime = durationTime + days + "dd ";
            } else {
                durationTime = durationTime + days + " \u064A\u0648\u0645 ";
            }
        }
        time.put("day", days);
        hh = minutes - new Integer(days) * 24 * 60;
        hours = Integer.toString((int) (hh / 60));
        if (hours != null && !hours.equals("") && !hours.equals("0")) {
            if (ConfigFileMgr.getCurrentlanguage().equals("En")) {
                durationTime = durationTime + hours + "hr ";
            } else {
                durationTime = durationTime + hours + " \u0633\u0627\u0639\u0629 ";
            }
        }
        time.put("hours", hours);
        mm = minutes - new Integer(days) * 24 * 60 - new Integer(hours) * 60;
        minute = Integer.toString(mm);
        if (minute != null && !minute.equals("") && !minute.equals("0")) {
            if (ConfigFileMgr.getCurrentlanguage().equals("En")) {
                durationTime = durationTime + minute + "mm ";
            } else {
                durationTime = durationTime + minute + " \u062F\u0642\u064A\u0642\u0629 ";
            }
        }
        time.put("minute", Integer.toString(mm));

        return durationTime;

    }

    public HashMap getDetailsDaysHourMinute(int minutes) {
        HashMap time = new HashMap();
        String days = null;
        String hours = null;
        String minute = null;
        int dd = 0;
        int hh = 0;
        int mm = 0;
        String durationTime = " ";

        dd = (minutes / 60) / 24;
        days = Integer.toString(dd);
        time.put("day", days);
        hh = minutes - new Integer(days) * 24 * 60;
        hours = Integer.toString((int) (hh / 60));
        time.put("hours", hours);
        mm = minutes - new Integer(days) * 24 * 60 - new Integer(hours) * 60;
        minute = Integer.toString(mm);
        time.put("minute", Integer.toString(mm));

        return time;

    }

    public HashMap<String, String> getDetailsHourMinute(int minutes) {
        HashMap<String, String> time = new HashMap<String, String>();
        String hours = "0";
        String minute = "0";
        int hh = 0;
        int mm = 0;

        hh = minutes / 60;
        mm = minutes - (hh * 60);

        hours = Integer.toString(hh);
        time.put("hours", hours);

        minute = Integer.toString(mm);
        time.put("minute", minute);

        return time;

    }

    public static Timestamp getTimestamp(String text) {
        text = text.replaceAll("-", "/");
        SimpleDateFormat dateformate = new SimpleDateFormat("yyyy/dd/MM HH:mm:ss");
        Timestamp timeStamp = null;

        try {
            Date date = dateformate.parse(text);
            timeStamp = new Timestamp(date.getTime());
        } catch (ParseException ex) {
            return null;
        }
        return timeStamp;
    }

    public static Timestamp getTimestamp2(String text) {
        text = text.replaceAll("-", "/");
        SimpleDateFormat dateformate = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        Timestamp timeStamp = null;

        try {
            Date date = dateformate.parse(text);
            timeStamp = new Timestamp(date.getTime());
        } catch (ParseException ex) {
            return null;
        }
        return timeStamp;
    }

    public static String getDateTimeFormatted(Timestamp timestamp) {
        SimpleDateFormat dateformate = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        String formatted = dateformate.format(timestamp);
        return formatted;
    }

    /**
     *
     * @param timestamp
     * @return Date String with the proper Format
     */
    public static String getArabicDateTimeFormatted(Timestamp timestamp) {
        SimpleDateFormat dateformate = new SimpleDateFormat("HH:mm dd-MM-yyyy");
        String formatted = dateformate.format(timestamp);
        return formatted;
    }

    public static String getArabicDateTimeFormatted(String date) {
        date = date.replaceAll("/", "-");
        String formatted = date;
        try {
            if (date.length() == 16) {
                date = date.concat(":00");
            }
            SimpleDateFormat arabicFormatter = new SimpleDateFormat("dd-MM-yyyy HH:mm");
            formatted = arabicFormatter.format(Timestamp.valueOf(date));
        } catch (Exception ex) {
            System.out.println(date + " not converted to dd-MM-yyyy HH:mm [" + ex + "]");
        }
        return formatted;
    }

    /**
     *
     * @param dateString after using SubString in last 5 chars
     * @return Date String with the proper Format
     * @throws ParseException
     */
    public static String getDateAfterSubString(String dateString) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date date = sdf.parse(dateString);
        Timestamp varTimestamp = new Timestamp(date.getTime());

        return getArabicDateTimeFormatted((Timestamp) varTimestamp);
    }

    public static Date getDate(String text) {
        text = text.replaceAll("-", "/");
        SimpleDateFormat dateformate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Date date;
        try {
            date = dateformate.parse(text);
        } catch (ParseException ex) {
            return null;
        }
        return date;
    }

    public static String getDelayTime(String begin, String stat) {

        StringBuffer sb = new StringBuffer();

        int NoMinutesInMonth = 43200;
        int NoMinutesInWeek = 10080;
        int NoMinutesInDay = 1440;
        int NoMinutesInHours = 60;
        long deffInMinutes = 0;
//        int day = 0;
        long week = 0, hour = 0, minutes = 0;
        boolean coma = false;
        DateFormat formatter = null;
        formatter = new SimpleDateFormat("dd/MM/yyyy");
        String[] arrDate = begin.split(" ");
        String sDate = arrDate[0];
        String sTime = arrDate[1];
        String[] arrTime = sTime.split(":");
        sTime = arrTime[0] + ":" + arrTime[1];
        sDate = sDate.replace("-", "/");
        arrDate = sDate.split("/");
        arrDate = sDate.split("/");
        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
        Calendar c = Calendar.getInstance();
        try {
            c.setTime((Date) formatter.parse(sDate));
        } catch (ParseException ex) {
            Logger.getLogger(DateAndTimeControl.class.getName()).log(Level.SEVERE, null, ex);
        }
//        long timeBrgin = getTimestamp(begin).getTime();
        long timeBrgin = c.getTimeInMillis();
        long timeNow = Calendar.getInstance().getTime().getTime();
//        Date dateTimeBegin = new Date(timeBrgin);
//        Date dateTimeNow = new Date(timeNow);
//        hour = dateTimeNow.getHours() - dateTimeBegin.getHours();
//        minutes = dateTimeNow.getMinutes() - dateTimeBegin.getMinutes();

        long deff = timeNow - timeBrgin;
        ///////////////
        long diffSeconds = deff / 1000 % 60;
        long diffMinutes = deff / (60 * 1000) % 60;
        long diffHours = deff / (60 * 60 * 1000) % 24;
        long diffDays = deff / (24 * 60 * 60 * 1000);
        //////////////
        long day = deff / (1000 * 60 * 60 * 24);
        long ee = deff % (1000 * 60 * 60 * 24);

//        if(deffInMinutes/NoMinutesInMonth > 0){
//            sb.append( String.valueOf(deffInMinutes/NoMinutesInMonth) + "Month ,");
//            deffInMinutes = deffInMinutes%NoMinutesInMonth;
//        }
//        week = (int)deffInMinutes/NoMinutesInWeek;
//        if(week > 0){
//            sb.append(String.valueOf(week) + "Week ,");
//            deffInMinutes = deffInMinutes%NoMinutesInWeek;
//        }
//        day = (int)deffInMinutes/NoMinutesInDay;
//        deffInMinutes = deffInMinutes%NoMinutesInDay;
//        hour = (int)deffInMinutes/NoMinutesInHours;
//        deffInMinutes = deffInMinutes%NoMinutesInHours;
        if (stat.equals("En")) {
            if (day > 0) {
                coma = true;
                if (day > 1) {
                    sb.append(String.valueOf(day));
                } else {
                    sb.append(String.valueOf(day));
                }
//                    deffInMinutes = deffInMinutes%NoMinutesInDay;
            }
//                hour = (int)deffInMinutes/NoMinutesInHours;
            if (hour > 0) {
//                    deffInMinutes = deffInMinutes%NoMinutesInHours;
                if (coma) {
                    if (deffInMinutes > 0) {
                        sb.append(" - ");
                        if (hour > 1) {
                            sb.append(String.valueOf(hour) + " Hours");
                        } else {
                            sb.append(String.valueOf(hour) + " Hour");
                        }
                    } else {
                        sb.append(" and ");
                        if (hour > 1) {
                            sb.append(String.valueOf(hour) + " Hours");
                        } else {
                            sb.append(String.valueOf(hour) + " Hour");
                        }
                    }
                } else {
                    if (hour > 1) {
                        sb.append(String.valueOf(hour) + " Hours");
                    } else {
                        sb.append(String.valueOf(hour) + " Hour");
                    }
                }
                coma = true;
            }
            if (deffInMinutes > 0) {
                if (coma) {
                    sb.append(" and ");
                }
                if (deffInMinutes > 1) {
                    sb.append(String.valueOf(deffInMinutes) + " Minutes");
                } else {
                    sb.append(String.valueOf(deffInMinutes) + " Minute");
                }
            }
            if (sb.length() == 0) {
                sb.append(" 1 " + " Minute");
            }
        } else {
            if (day > 0) {
                coma = true;
                sb.append(String.valueOf(day));
//                    deffInMinutes = deffInMinutes%NoMinutesInDay;
            } else {
                coma = true;
                sb.append(String.valueOf(0));
            }
//               hour = (int)deffInMinutes/NoMinutesInHours;
            if (hour > 0) {
//                    deffInMinutes = deffInMinutes%NoMinutesInHours;
                if (coma) {
                    if (deffInMinutes > 0) {
                        sb.append(" - ");
                        sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                    } else {
                        sb.append(" &#1608; ");
                        sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                    }
                } else {
                    sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                }
                coma = true;
            }
            if (deffInMinutes > 0) {
                if (coma) {
                    sb.append(" &#1608; ");
                }
                sb.append(String.valueOf(deffInMinutes) + " &#1583;&#1602;&#1610;&#1602;&#1577;");
            }
//                if(sb.length() == 0) sb.append( " 1 " + " &#1583;&#1602;&#1610;&#1602;&#1577;");
        }

        return sb.toString();
    }

    public static String getDelayTimeByDay(String begin, String stat) {
        StringBuilder builder = new StringBuilder();

        if (!begin.contains(" ")) {
            begin = begin + " 00:00:00";
        }

        long timeBegin = getTimestamp2(begin).getTime();
        long timeNow = Calendar.getInstance().getTime().getTime();

        long defference = timeNow - timeBegin;
        int day = (int) (defference / (1000 * 60 * 60 * 24));
        int hours = (int) (defference / (1000 * 60 * 60));
        if (day == 0) {
            if (stat.equals("En")) {
                builder.append("Today from- ").append(hours).append(" hour");
            } else {
                if (hours == 1) {
                    builder.append("\u0645\u0646- ").append(" \u0633\u0627\u0639\u0629");
                } else {
                    builder.append("\u0645\u0646- ").append(hours).append(" \u0633\u0627\u0639\u0627\u062A");
                }
            }
        } else {
            if (stat.equals("En")) {
                builder.append(String.valueOf(day)).append(" Day(s)");
            } else {
                builder.append(String.valueOf(day)).append(" \u064A\u0648\u0645");
            }
        }

        return builder.toString();
    }

    public static String getDelayTimeHex(String begin, String stat) {

        StringBuffer sb = new StringBuffer();

        int NoMinutesInDay = 1440;
        int NoMinutesInHours = 60;
        int day = 0, hour = 0;
        boolean coma = false;

        long timeBrgin = getTimestamp(begin).getTime();
        long timeNow = Calendar.getInstance().getTime().getTime();

        long deff = timeNow - timeBrgin;
        long deffInMinutes = deff / (1000 * 60);
        long ee = deffInMinutes % (1000 * 60);

        day = (int) deffInMinutes / NoMinutesInDay;
        deffInMinutes = deffInMinutes % NoMinutesInDay;
        hour = (int) deffInMinutes / NoMinutesInHours;
        deffInMinutes = deffInMinutes % NoMinutesInHours;

        if (stat.equals("En")) {
            if (day > 0) {
                coma = true;
                if (day > 1) {
                    sb.append(String.valueOf(day) + " Days");
                } else {
                    sb.append(String.valueOf(day) + " Day");
                }
            }

            if (hour > 0) {

                if (coma) {
                    if (deffInMinutes > 0) {
                        sb.append(" - ");
                        if (hour > 1) {
                            sb.append(String.valueOf(hour) + " Hours");
                        } else {
                            sb.append(String.valueOf(hour) + " Hour");
                        }
                    } else {
                        sb.append(" and ");
                        if (hour > 1) {
                            sb.append(String.valueOf(hour) + " Hours");
                        } else {
                            sb.append(String.valueOf(hour) + " Hour");
                        }
                    }
                } else {
                    if (hour > 1) {
                        sb.append(String.valueOf(hour) + " Hours");
                    } else {
                        sb.append(String.valueOf(hour) + " Hour");
                    }
                }
                coma = true;
            }

            if (deffInMinutes > 0) {
                if (coma) {
                    sb.append(" and ");
                }
                if (deffInMinutes > 1) {
                    sb.append(String.valueOf(deffInMinutes) + " Minutes");
                } else {
                    sb.append(String.valueOf(deffInMinutes) + " Minute");
                }
            }

            if (sb.length() == 0) {
                sb.append(" 1 " + " Minute");
            }

        } else {

            if (day > 0) {
                coma = true;
                sb.append(String.valueOf(day) + " \u064A\u0648\u0645");

            }

            if (hour > 0) {

                if (coma) {
                    if (deffInMinutes > 0) {
                        sb.append(" - ");
                        sb.append(String.valueOf(hour) + " \u0633\u0627\u0639\u0629");
                    } else {
                        sb.append(" \u0648 ");
                        sb.append(String.valueOf(hour) + " \u0633\u0627\u0639\u0629");
                    }
                } else {
                    sb.append(String.valueOf(hour) + " \u0633\u0627\u0639\u0629");
                }
                coma = true;
            }
            if (deffInMinutes > 0) {
                if (coma) {
                    sb.append(" \u0648 ");
                }
                sb.append(String.valueOf(deffInMinutes) + " \u062F\u0642\u064A\u0642\u0629");
            }
            if (sb.length() == 0) {
                sb.append(" 1 " + " \u062F\u0642\u064A\u0642\u0629");
            }
        }

        return sb.toString();
    }

    public static String getDelayTime(String begin, String end, String stat) {

        StringBuffer sb = new StringBuffer();

        int NoMinutesInMonth = 43200;
        int NoMinutesInWeek = 10080;
        int NoMinutesInDay = 1440;
        int NoMinutesInHours = 60;
        int day = 0, week = 0, hour = 0, minutes = 0;
        boolean coma = false;

        long timeBrgin = getTimestamp2(begin).getTime();
        long timeEnd = getTimestamp2(end).getTime();
//        Date dateTimeBegin = new Date(timeBrgin);
//        Date dateTimeNow = new Date(timeNow);
//        hour = dateTimeNow.getHours() - dateTimeBegin.getHours();
//        minutes = dateTimeNow.getMinutes() - dateTimeBegin.getMinutes();

        long deff = timeEnd - timeBrgin;
        long deffInMinutes = deff / (1000 * 60);
        long ee = deffInMinutes % (1000 * 60);

//        if(deffInMinutes/NoMinutesInMonth > 0){
//            sb.append( String.valueOf(deffInMinutes/NoMinutesInMonth) + "Month ,");
//            deffInMinutes = deffInMinutes%NoMinutesInMonth;
//        }
//        week = (int)deffInMinutes/NoMinutesInWeek;
//        if(week > 0){
//            sb.append(String.valueOf(week) + "Week ,");
//            deffInMinutes = deffInMinutes%NoMinutesInWeek;
//        }
        day = (int) deffInMinutes / NoMinutesInDay;
        deffInMinutes = deffInMinutes % NoMinutesInDay;
        hour = (int) deffInMinutes / NoMinutesInHours;
        deffInMinutes = deffInMinutes % NoMinutesInHours;
        if (stat.equals("En")) {
            if (day > 0) {
                coma = true;
                if (day > 1) {
                    sb.append(" Days " + String.valueOf(day));
                } else {
                    sb.append(" Days " + String.valueOf(day));
                }
//                    deffInMinutes = deffInMinutes%NoMinutesInDay;
            }
//                hour = (int)deffInMinutes/NoMinutesInHours;
            if (hour > 0) {
//                    deffInMinutes = deffInMinutes%NoMinutesInHours;
                if (coma) {
                    if (deffInMinutes > 0) {

                        if (hour > 1) {
                            sb.append("-" + String.valueOf(hour) + " Hours" + "-");
                        } else {
                            sb.append("-" + String.valueOf(hour) + " Hour" + "-");
                        }
                    } else {

                        if (hour > 1) {
                            sb.append("-" + String.valueOf(hour) + " Hours" + "-");
                        } else {
                            sb.append("-" + String.valueOf(hour) + " Hour" + "-");
                        }
                    }
                } else {
                    if (hour > 1) {
                        sb.append("-" + String.valueOf(hour) + " Hours" + "-");
                    } else {
                        sb.append("-" + String.valueOf(hour) + " Hour" + "-");
                    }
                }
                coma = true;
            }
            if (deffInMinutes > 0) {
//                if (coma) {
//                    sb.append(" and ");
//                }
                if (deffInMinutes > 1) {
                    sb.append(String.valueOf(deffInMinutes) + " Minutes");
                } else {
                    sb.append(String.valueOf(deffInMinutes) + " Minute");
                }
            }
            if (sb.length() == 0) {
                sb.append(" 1 " + " Minute");
            }
        } else {
            if (day > 0) {
                coma = true;
                sb.append(String.valueOf(day) + " &#1610;&#1608;&#1605;");
//                    deffInMinutes = deffInMinutes%NoMinutesInDay;
            }
//               hour = (int)deffInMinutes/NoMinutesInHours;
            if (hour > 0) {
//                    deffInMinutes = deffInMinutes%NoMinutesInHours;
                if (coma) {
                    if (deffInMinutes > 0) {
                        sb.append(" - ");
                        sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                    } else {
                        sb.append(" &#1608; ");
                        sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                    }
                } else {
                    sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                }
                coma = true;
            }
            if (deffInMinutes > 0) {
                if (coma) {
                    sb.append(" &#1608; ");
                }
                sb.append(String.valueOf(deffInMinutes) + " &#1583;&#1602;&#1610;&#1602;&#1577;");
            }
            if (sb.length() == 0) {
                sb.append(" 1 " + " &#1583;&#1602;&#1610;&#1602;&#1577;");
            }
        }

        return sb.toString();
    }

    public static String getDelayTime2(String begin, String end, String stat) {

        StringBuffer sb = new StringBuffer();

        int NoMinutesInMonth = 43200;
        int NoMinutesInWeek = 10080;
        int NoMinutesInDay = 1440;
        int NoMinutesInHours = 60;
        int day = 0, week = 0, hour = 0, minutes = 0;
        boolean coma = false;

        long timeBrgin = getTimestamp2(begin).getTime();
        long timeEnd = getTimestamp2(end).getTime();

        long deff = timeEnd - timeBrgin;
        long deffInMinutes = deff / (1000 * 60);
        long ee = deffInMinutes % (1000 * 60);

        day = (int) deffInMinutes / NoMinutesInDay;
        deffInMinutes = deffInMinutes % NoMinutesInDay;
        hour = (int) deffInMinutes / NoMinutesInHours;
        deffInMinutes = deffInMinutes % NoMinutesInHours;

        String days = "";
        String hours = "";
        String min = "";
        if (stat.equals("En")) {
            if (day > 0) {
                coma = true;
                if (day > 1) {
                    sb.append(" Days " + String.valueOf(day));
                    days = String.valueOf(day);
                } else {
                    sb.append(" Days " + String.valueOf(day));
                    days = String.valueOf(day);
                }

            }

            if (hour > 0) {
                if (coma) {
                    if (deffInMinutes > 0) {

                        if (hour > 1) {
                            sb.append("-" + String.valueOf(hour) + " Hours" + "-");
                            hours = String.valueOf(hour);
                        } else {
                            sb.append("-" + String.valueOf(hour) + " Hour" + "-");
                            hours = String.valueOf(hour);
                        }
                    } else {

                        if (hour > 1) {
                            sb.append("-" + String.valueOf(hour) + " Hours" + "-");
                            hours = String.valueOf(hour);
                        } else {
                            sb.append("-" + String.valueOf(hour) + " Hour" + "-");
                            hours = String.valueOf(hour);
                        }
                    }
                } else {
                    if (hour > 1) {
                        sb.append("-" + String.valueOf(hour) + " Hours" + "-");
                        hours = String.valueOf(hour);
                    } else {
                        sb.append("-" + String.valueOf(hour) + " Hour" + "-");
                        hours = String.valueOf(hour);
                    }
                }
                coma = true;
            }
            if (deffInMinutes > 0) {

                if (deffInMinutes > 1) {
                    sb.append(String.valueOf(deffInMinutes) + " Minutes");
                    min = String.valueOf(deffInMinutes);
                } else {
                    sb.append(String.valueOf(deffInMinutes) + " Minute");
                    min = String.valueOf(deffInMinutes);
                }
            }
            if (sb.length() == 0) {
                sb.append(" 1 " + " Minute");
                min = String.valueOf(deffInMinutes);
            }
        } else {
            if (day > 0) {
                coma = true;
                sb.append(String.valueOf(day) + " &#1610;&#1608;&#1605;");
            }

            if (hour > 0) {
                if (coma) {
                    if (deffInMinutes > 0) {
                        sb.append(" - ");
                        sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                    } else {
                        sb.append(" &#1608; ");
                        sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                    }
                } else {
                    sb.append(String.valueOf(hour) + " &#1587;&#1575;&#1593;&#1577;");
                }
                coma = true;
            }
            if (deffInMinutes > 0) {
                if (coma) {
                    sb.append(" &#1608; ");
                }
                sb.append(String.valueOf(deffInMinutes) + " &#1583;&#1602;&#1610;&#1602;&#1577;");
            }
            if (sb.length() == 0) {
                sb.append(" 1 " + " &#1583;&#1602;&#1610;&#1602;&#1577;");
            }
        }
        String newFormat = "";
        if (sb.length() == 0) {
            newFormat = " 1 Minute ";
        } else {
            if (days.length() > 0 & hours.length() > 0 & min.length() > 0) {
                newFormat = days + "day - " + hours + " hours - " + min + " minutes";
            } else if (days.length() > 0 & hours.length() > 0) {
                newFormat = days + "day - " + hours + " hours";
            } else if (hours.length() > 0 & min.length() > 0) {
                newFormat = hours + "hours - " + min + " minutes";
            } else if (days.length() > 0) {
                newFormat = days + "day";
            } else if (hours.length() > 0) {
                newFormat = hours + "hours";
            } else if (min.length() > 0) {
                if (min.equals("0")) {
                    min = "less than ";
                }
                newFormat = min + "minutes";
            }
        }
        return newFormat;
    }

    public static String trimSecond(String fullTime) {
        String sub1, sub2;
        int lastIndex = fullTime.length() - 1;
        if (lastIndex > 6) {
            sub1 = fullTime.substring(0, lastIndex - 5);
            sub2 = fullTime.substring(lastIndex - 2, lastIndex + 1);
            return sub1 + sub2;
        } else {
            return fullTime;
        }
    }

    public static String getTimeRemainingFormatted(String time, TimeType type, String state) {
        int timeRemaining = 0;
        int realTime;
        TimeType realType;
        try {
            timeRemaining = (int) (Integer.parseInt(time) * type.getValueBySeconds());
            if (timeRemaining / TimeType.MINUTES.getValueBySeconds() <= 1) {
                realType = TimeType.SECONDS;
                realTime = timeRemaining;
            } else if (timeRemaining / TimeType.HOURS.getValueBySeconds() <= 1) {
                realType = TimeType.MINUTES;
                realTime = timeRemaining / (int) TimeType.MINUTES.getValueBySeconds();
            } else if (timeRemaining / TimeType.DAYS.getValueBySeconds() <= 1) {
                realType = TimeType.HOURS;
                realTime = timeRemaining / (int) TimeType.HOURS.getValueBySeconds();
            } else if (timeRemaining / TimeType.WEEKS.getValueBySeconds() <= 1) {
                realType = TimeType.DAYS;
                realTime = timeRemaining / (int) TimeType.DAYS.getValueBySeconds();
            } else if (timeRemaining / TimeType.MONTHS.getValueBySeconds() <= 1) {
                realType = TimeType.WEEKS;
                realTime = timeRemaining / (int) TimeType.WEEKS.getValueBySeconds();
            } else if (timeRemaining / TimeType.YEARS.getValueBySeconds() <= 1) {
                realType = TimeType.MONTHS;
                realTime = timeRemaining / (int) TimeType.MONTHS.getValueBySeconds();
            } else {
                realType = TimeType.YEARS;
                realTime = timeRemaining / (int) TimeType.YEARS.getValueBySeconds();
            }

            return realTime + " <font color=\"blue\">" + realType.getDescription(state) + "</font>";
        } catch (NumberFormatException ex) {
            System.err.println("Error: " + ex);
        }
        return null;
    }

    public static String getOracleDateTimeNowAsString() {
        DateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        return formatter.format(Calendar.getInstance().getTime());
    }

    public static Timestamp getOracleDateTimeNow() {
        return new Timestamp(Calendar.getInstance().getTimeInMillis());
    }

    public static WebBusinessObject getFormattedDateTime(String dateTime, String stat) throws Exception {
        WebBusinessObject wbo = new WebBusinessObject();
        String sat, sun, mon, tue, wed, thu, fri, today;
        Calendar c = Calendar.getInstance();
        DateFormat formatter;
        formatter = new SimpleDateFormat("dd/MM/yyyy");
        String[] arrDate = dateTime.split(" ");
        Date date = new Date();
        String sDate = arrDate[0];
        String sTime = arrDate[1];
        String[] arrTime = sTime.split(":");
        sTime = arrTime[0] + ":" + arrTime[1];
        sDate = sDate.replace("-", "/");
        arrDate = sDate.split("/");
        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
        c.setTime((Date) formatter.parse(sDate));
        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        String currentDate = formatter.format(date);
        String sDay = null;

        if (stat.equalsIgnoreCase("ar")) {
            sat = "السبت";
            sun = "الاحد";
            mon = "الاثنين";
            tue = "الثلاثاء";
            wed = "الاربعاء";
            thu = "الخميس";
            fri = "الجمعة";
            today = "اليوم";
        } else {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
        }

        if (dayOfWeek == 7) {
            sDay = sat;
        } else if (dayOfWeek == 1) {
            sDay = sun;
        } else if (dayOfWeek == 2) {
            sDay = mon;
        } else if (dayOfWeek == 3) {
            sDay = tue;
        } else if (dayOfWeek == 4) {
            sDay = wed;
        } else if (dayOfWeek == 5) {
            sDay = thu;
        } else if (dayOfWeek == 6) {
            sDay = fri;
        }

        if ((currentDate.equals(sDate))) {
            wbo.setAttribute("day", today);
            wbo.setAttribute("time", sTime);
        } else {
            wbo.setAttribute("day", sDay);
            wbo.setAttribute("time", sDate + " " + sTime);
        }
        return wbo;
    }

    public static WebBusinessObject getFormattedDateTime2(String dateTime, String stat) throws Exception {
        WebBusinessObject wbo = new WebBusinessObject();
        String sat, sun, mon, tue, wed, thu, fri, today;
        Calendar c = Calendar.getInstance();
        DateFormat formatter;
        formatter = new SimpleDateFormat("yyyy/MM/dd");
        String[] arrDate = dateTime.split(" ");
        Date date = new Date();
        String sDate = arrDate[0];
        String sTime = arrDate[1];
        String[] arrTime = sTime.split(":");
        sTime = arrTime[0] + ":" + arrTime[1];
        sDate = sDate.replace("-", "/");
        arrDate = sDate.split("/");
        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
        c.setTime((Date) formatter.parse(sDate));
        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        String currentDate = formatter.format(date);
        String sDay = null;

        if (stat.equalsIgnoreCase("ar")) {
            sat = "السبت";
            sun = "الاحد";
            mon = "الاثنين";
            tue = "الثلاثاء";
            wed = "الاربعاء";
            thu = "الخميس";
            fri = "الجمعة";
            today = "اليوم";
        } else {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
        }

        if (dayOfWeek == 7) {
            sDay = sat;
        } else if (dayOfWeek == 1) {
            sDay = sun;
        } else if (dayOfWeek == 2) {
            sDay = mon;
        } else if (dayOfWeek == 3) {
            sDay = tue;
        } else if (dayOfWeek == 4) {
            sDay = wed;
        } else if (dayOfWeek == 5) {
            sDay = thu;
        } else if (dayOfWeek == 6) {
            sDay = fri;
        }

        if ((currentDate.equals(sDate))) {
            wbo.setAttribute("day", today);
            wbo.setAttribute("time", sTime);
        } else {
            wbo.setAttribute("day", sDay);
            wbo.setAttribute("time", sDate + " " + sTime);
        }
        return wbo;
    }

    public static WebBusinessObject getFormattedDateTime(Date date, String stat) throws Exception {
        WebBusinessObject wbo = new WebBusinessObject();

        String sat, sun, mon, tue, wed, thu, fri, today, am, pm, amPm;
        Calendar calendar = Calendar.getInstance();
        DateFormat formatter;
        formatter = new SimpleDateFormat("dd/MM/yyyy");
        String currentDate = formatter.format(date);
        calendar.setTime(date);
        String dateOnly = formatter.format(date);
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        String time = calendar.get(Calendar.HOUR) + ":" + calendar.get(Calendar.MINUTE);
        String day = null;
        if (stat.equalsIgnoreCase("ar")) {
            sat = "السبت";
            sun = "الاحد";
            mon = "الاثنين";
            tue = "الثلاثاء";
            wed = "الاربعاء";
            thu = "الخميس";
            fri = "الجمعة";
            today = "اليوم";
            am = "ص ";
            pm = "م ";
        } else {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
            am = " AM";
            pm = " PM";
        }

        if (dayOfWeek == 7) {
            day = sat;
        } else if (dayOfWeek == 1) {
            day = sun;
        } else if (dayOfWeek == 2) {
            day = mon;
        } else if (dayOfWeek == 3) {
            day = tue;
        } else if (dayOfWeek == 4) {
            day = wed;
        } else if (dayOfWeek == 5) {
            day = thu;
        } else if (dayOfWeek == 6) {
            day = fri;
        }
        if (calendar.get(Calendar.AM_PM) == Calendar.AM) {
            amPm = am;
        } else {
            amPm = pm;
        }

        if ((currentDate.equals(dateOnly))) {
            wbo.setAttribute("day", today);
            wbo.setAttribute("time", time + amPm);
        } else {
            wbo.setAttribute("day", day);
            wbo.setAttribute("time", dateOnly + " " + time + amPm);
        }
        return wbo;
    }

    public static String getStanderdFormat(String dateTime, String stat) {
        String value = null;
        try {
            WebBusinessObject wbo = getFormattedDateTime(dateTime, stat);
            value = "<font color=\"red\">" + wbo.getAttribute("day") + "</font> - <b>" + wbo.getAttribute("time") + "</b>";
        } catch (Exception ex) {
        }
        return value;
    }

    public static String getStanderdFormat(Date date, String stat) {
        String value = null;
        try {
            WebBusinessObject wbo = getFormattedDateTime(date, stat);
            value = "<font color=\"red\">" + wbo.getAttribute("day") + "</font> - <b>" + wbo.getAttribute("time") + "</b>";
        } catch (Exception ex) {
        }
        return value;
    }

    public static CustomDate getDelayTime(int duration) {
        int days;
        int hours;
        int minutes;
        int noMinutesInDay = 1440;
        int NoMinutesInHours = 60;

        minutes = duration;
        days = minutes / noMinutesInDay;
        minutes = minutes % noMinutesInDay;
        hours = minutes / NoMinutesInHours;
        minutes = minutes % NoMinutesInHours;

        return new CustomDate(days, hours, minutes);
    }

    public static CustomDate getDelayTime(Timestamp begin, Timestamp end) {
        int days;
        int hours;
        int minutes;
        int noMinutesInDay = 1440;
        int NoMinutesInHours = 60;

        minutes = (int) ((end.getTime() - begin.getTime()) / (60000));
        days = minutes / noMinutesInDay;
        minutes = minutes % noMinutesInDay;
        hours = minutes / NoMinutesInHours;
        minutes = minutes % NoMinutesInHours;

        return new CustomDate(days, hours, minutes);
    }

    public static class CustomDate {

        private int days;
        private int hours;
        private int minutes;

        public CustomDate() {
            this(0, 0, 0);
        }

        public CustomDate(int days, int hours, int minutes) {
            this.days = days;
            this.hours = hours;
            this.minutes = minutes;
        }

        public int getDays() {
            return days;
        }

        public void setDays(int days) {
            this.days = days;
        }

        public int getHours() {
            return hours;
        }

        public void setHours(int hours) {
            this.hours = hours;
        }

        public int getMinutes() {
            return minutes;
        }

        public void setMinutes(int minutes) {
            this.minutes = minutes;
        }

        public static String getAsString(int value) {
//            if (value > 0) {
//                return "" + value;
//            }
//            return "--";
            return "" + value;
        }

        public static CustomDate sum(List<CustomDate> customs) {
            int days = 0;
            int hours = 0;
            int minutes = 0;

            for (CustomDate custom : customs) {
                days += custom.getDays();
                hours += custom.getHours();
                minutes += custom.getMinutes();
            }

            days += hours / 24;
            hours = hours % 24;
            hours += minutes / 60;
            minutes = minutes % 60;

            return new CustomDate(days, hours, minutes);
        }
    }

    public enum TimeType {

        MILLISECONDS("Milli Seconds", 1.0f / 1000, "ملى ثانية", "Milli Second(s)"),
        SECONDS("Seconds", 1, "ثانية", "Second(s)"),
        MINUTES("Minutes", 60, "دقائق", "Minute(s)"),
        HOURS("Hours", 3600, "ساعات", "Hour(s)"),
        DAYS("Days", 3600 * 24, "ايام", "Day(s)"),
        WEEKS("Weeks", 3600 * 24 * 7, "اسابيع", "Week(s)"),
        MONTHS("Months", 3600 * 24 * 30, "شهور", "Month(s)"),
        YEARS("Years", 3600 * 24 * 30 * 12, "سنوات", "Year(s)");

        private final String type;
        private final String ar;
        private final String en;
        private final float valueBySeconds;

        private TimeType(String type, float valueBySeconds, String ar, String en) {
            this.type = type;
            this.valueBySeconds = valueBySeconds;
            this.ar = ar;
            this.en = en;
        }

        public String getType() {
            return type;
        }

        public float getValueBySeconds() {
            return valueBySeconds;
        }

        public String getDescription(String state) {
            return ("Ar".equalsIgnoreCase(state)) ? ar : en;
        }

        @Override
        public String toString() {
            return "Type: " + type + ", Value By Seconds: " + valueBySeconds;
        }
    }

    public Vector calculateDateDiff(String beginDate, String endDate) {
        Vector dateTimeVec = new Vector();

        String dateStart = beginDate;
        String dateStop = endDate;

        //HH converts hour in 24 hours format (0-23), day calculation
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        Date d1 = null;
        Date d2 = null;

        try {
            d1 = format.parse(dateStart);
            d2 = format.parse(dateStop);

            //in milliseconds
            long diff = d2.getTime() - d1.getTime();

            long diffSeconds = diff / 1000 % 60;
            long diffMinutes = diff / (60 * 1000) % 60;
            long diffHours = diff / (60 * 60 * 1000) % 24;
            long diffDays = diff / (24 * 60 * 60 * 1000);

            dateTimeVec.add(diffDays);
            dateTimeVec.add(diffHours);
            dateTimeVec.add(diffMinutes);
            dateTimeVec.add(diffSeconds);

            System.out.print(diffDays + " days, ");
            System.out.print(diffHours + " hours, ");
            System.out.print(diffMinutes + " minutes, ");
            System.out.print(diffSeconds + " seconds.");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dateTimeVec;
    }
}
