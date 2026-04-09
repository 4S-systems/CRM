<%-- 
    Document   : Ajax_Code
    Created on : Mar 4, 2012, 11:18:04 AM
    Author     : Waled
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%!    Calendar calendar = Calendar.getInstance();
    int year = calendar.get(Calendar.YEAR);

    public String getNameOfMonth(int monthNumber) {
        String monthName = "invalid";
        DateFormatSymbols dfs = new DateFormatSymbols();
        String[] months = dfs.getMonths();
        if (monthNumber >= 0 && monthNumber <= 11) {
            monthName = months[monthNumber];
        }
        return monthName;
    }

    public String beforeDate(int i, int j) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        int date = 0;
        calendar.set(year, i, date);
        calendar.add(Calendar.DATE, -j);
        String newDate = sdf.format(calendar.getTime());
        return newDate;
    }

    public String afterDate(int i, int j) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        int days = getNumberOfDaysInmonth(i, year);
        calendar.set(year, i, days);
        calendar.add(Calendar.DATE, j);
        String newDate = sdf.format(calendar.getTime());
        return newDate;
    }

    public int getNumberOfDaysInmonth(int i, int year) {
        int date = 1;
        calendar.set(year, i, date);
        int days = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        return days;
    }
%>
<%
    ArrayList wbo = (ArrayList) request.getAttribute("code");
%>

<%
    String allCode = "{" + "\"arabicName\"" + ":\"" + ((WebBusinessObject) wbo.get(0)).getAttribute("arabicName") + "\"" + ","
            + "\"englishName\"" + ": \"" + ((WebBusinessObject) wbo.get(0)).getAttribute("englishName") + "\"" + "}";
%>
<%=allCode%>