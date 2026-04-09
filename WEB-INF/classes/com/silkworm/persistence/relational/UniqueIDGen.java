package com.silkworm.persistence.relational;

import java.util.*;

public class UniqueIDGen {

    public UniqueIDGen() {
    }

    public static synchronized String getNextID() {
        try {
            Thread.sleep(10);
        } catch (InterruptedException ex) {
            System.out.println(ex);
        }

        Date date = Calendar.getInstance().getTime();
        long id = date.getTime();

        String stringID = new Long(id).toString();
        return stringID;
    }
}
