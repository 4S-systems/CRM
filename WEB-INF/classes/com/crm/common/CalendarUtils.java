/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.common;

import java.text.DateFormatSymbols;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 *
 * @author haytham
 */
public class CalendarUtils {

    public final static Integer DEFAULT_START_YEAR = 2005;
    public final static Integer DEFAULT_END_YEAR = 2040;

    public final static int JANUARY = Calendar.JANUARY;
    public final static int FEBRUARY = Calendar.FEBRUARY;
    public final static int MARCH = Calendar.MARCH;
    public final static int APRIL = Calendar.APRIL;
    public final static int MAY = Calendar.MAY;
    public final static int JUNE = Calendar.JUNE;
    public final static int JULY = Calendar.JULY;
    public final static int AUGUST = Calendar.AUGUST;
    public final static int SEPTEMBER = Calendar.SEPTEMBER;
    public final static int OCTOBER = Calendar.OCTOBER;
    public final static int NOVEMBER = Calendar.NOVEMBER;
    public final static int DECEMBER = Calendar.DECEMBER;

    private final static CalendarUtils UTIL = new CalendarUtils();
    private final DateFormatSymbols symbols;

    private CalendarUtils() {
        this(Locale.getDefault());
    }

    private CalendarUtils(Locale locale) {
        symbols = new DateFormatSymbols(locale);
    }

    public static CalendarUtils getInstance() {
        return UTIL;
    }

    public static CalendarUtils getInstance(Locale locale) {
        return new CalendarUtils(locale);
    }

    public List<Integer> getDefaultYears() {
        List<Integer> years = new ArrayList<Integer>();
        for (int year = DEFAULT_START_YEAR; year <= DEFAULT_END_YEAR; year++) {
            years.add(new Integer(year));
        }
        return years;
    }

    public List<Month> getMonths() {
        List<Month> months = new ArrayList<Month>();
        String[] monthsNames = symbols.getMonths();
        for (int i = 0; i < monthsNames.length - 1; i++) {
            months.add(new Month(monthsNames[i], i));
        }
        return months;
    }

    public List<Month> getMonthsShort() {
        List<Month> months = new ArrayList<Month>();
        String[] monthsNames = symbols.getShortMonths();
        for (int i = 0; i < monthsNames.length; i++) {
            months.add(new Month(monthsNames[i], i));
        }
        return months;
    }

    public Calendar getCalendar() {
        return Calendar.getInstance();
    }

    public Calendar getCalendar(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar;
    }

    public Calendar getCalendar(int year, int month) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, year);
        calendar.set(Calendar.MONTH, month);
        calendar.set(Calendar.DATE, 1);
        return calendar;
    }

    public int getMonthLastDay(int year, int month) {
        return getCalendar(year, month).getActualMaximum(Calendar.DATE);
    }

    public int getMonthFirstDay(int year, int month) {
        return getCalendar(year, month).getMinimum(Calendar.DATE);
    }

    public Date getDate(int year, int month, int day) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day);
        return calendar.getTime();
    }

    public Day getDay(Date date) {
        return getDay(symbols.getWeekdays(), date);
    }

    public Day getDayShort(Date date) {
        return getDay(symbols.getShortWeekdays(), date);
    }

    public List<Day> getDays(Date fromDate, Date toDate) {
        return getDays(symbols.getWeekdays(), fromDate, toDate);
    }

    public List<Day> getDays(Date fromDate, int numberOfMonth) {
        Calendar calendar = getCalendar(fromDate);
        calendar.add(Calendar.MONTH, (numberOfMonth - 1));
        calendar.set(Calendar.DATE, getMonthLastDay(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH)));
        return getDays(symbols.getWeekdays(), fromDate, calendar.getTime());
    }

    public List<Day> getDays(Calendar fromCalendar, int numberOfMonth) {
        Calendar calendar = getCalendar(fromCalendar.getTime());
        calendar.add(Calendar.MONTH, (numberOfMonth - 1));
        calendar.set(Calendar.DATE, getMonthLastDay(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH)));
        return getDays(symbols.getWeekdays(), fromCalendar.getTime(), calendar.getTime());
    }

    public List<Day> getDaysShort(Date fromDate, Date toDate) {
        return getDays(symbols.getShortWeekdays(), fromDate, toDate);
    }

    public List<Day> getDaysShort(Date fromDate, int numberOfMonth) {
        Calendar calendar = getCalendar(fromDate);
        calendar.add(Calendar.MONTH, numberOfMonth);
        return getDays(symbols.getShortWeekdays(), fromDate, calendar.getTime());
    }

    public List<Day> getDaysShort(Calendar fromCalendar, int numberOfMonth) {
        Calendar calendar = getCalendar(fromCalendar.getTime());
        calendar.add(Calendar.MONTH, (numberOfMonth - 1));
        calendar.set(Calendar.DATE, getMonthLastDay(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH)));
        return getDays(symbols.getShortWeekdays(), fromCalendar.getTime(), calendar.getTime());
    }

    private List<Day> getDays(String[] names, Date fromDate, Date toDate) {
        List<Day> days = new ArrayList<Day>();
        Calendar fromCalendar = getCalendar(fromDate);
        Calendar toCalendar = getCalendar(toDate);
        while (fromCalendar.before(toCalendar) || fromCalendar.equals(toCalendar)) {
            days.add(getDay(names, fromCalendar));
            fromCalendar.add(Calendar.DATE, 1);
        }
        return days;
    }

    private Day getDay(String[] names, Date date) {
        Calendar calendar = getCalendar(date);
        return getDay(names, calendar);
    }

    private Day getDay(String[] names, Calendar calendar) {
        int day = calendar.get(Calendar.DATE);
        int dayInWeek = calendar.get(Calendar.DAY_OF_WEEK);
        String name = names[dayInWeek];
        return new Day(name, day, calendar.getTime());
    }

    public class Month {

        private final String name;
        private final int number;

        public Month(String name, int number) {
            this.name = name;
            this.number = number;
        }

        public String getName() {
            return name;
        }

        public int getNumber() {
            return number;
        }
    }

    public class Day {

        private final String name;
        private final int day;
        private final Date date;

        public Day(String name, int day, Date date) {
            this.name = name;
            this.day = day;
            this.date = date;
        }

        public String getName() {
            return name;
        }

        public int getDay() {
            return day;
        }

        public Date getDate() {
            return date;
        }

        @Override
        public String toString() {
            return "Name: " + name + ", Day: " + day + ", Date: " + date.toString();
        }
    }

    public static void main(String[] args) {
        Calendar calendar = Calendar.getInstance();
//        calendar.set(2012, FEBRUARY, 1);

        List<Day> days = getInstance().getDays(calendar.getTime(), 1);
        for (Day day : days) {
            System.out.println(day);
        }
    }
}
