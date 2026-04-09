package com.maintenance.common;

import java.sql.Date;

public class EquipmentWorkOrderTools {

  
    private static DateParser dateParser = new DateParser();

    public static Date getBeginDate(String beginDate){

        Date sqlBeginDate = dateParser.formatSqlDate(beginDate);
        return sqlBeginDate;
        
    }
    
    public static Date getEndDate(String endDate){

        Date sqlEndDate = dateParser.formatSqlDate(endDate);

        sqlEndDate.setDate(sqlEndDate.getDate() + 1);
        return sqlEndDate;
        
    }
}
