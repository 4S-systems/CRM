/*
 * DaytimeServer.java
 *
 * Created on March 20, 2004, 10:11 PM
 */

package com.docviewer.servlets;

import java.util.Date;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface DaytimeServer extends Remote {
  public Date getDate() throws RemoteException;
}

