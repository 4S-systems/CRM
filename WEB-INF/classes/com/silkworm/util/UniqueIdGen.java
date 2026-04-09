/*
 * UniqueIDGen.java
 *
 * Created on March 27, 2005, 2:01 PM
 */

package com.silkworm.util;

/**
 *
 * @author Walid
 */

import java.util.*;

public class UniqueIdGen {

  public UniqueIdGen() {
  }

  public static synchronized String getNextID()
  {
    Date d = Calendar.getInstance().getTime();
    long id = d.getTime();

    String stringID = new Long(id).toString();

    return stringID;
  }
}