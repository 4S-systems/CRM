/*
 * SessionEvent.java
 *
 * Created on December 21, 2003, 9:51 AM
 */
package com.silkworm.system_events;

/**
 *
 * @author walid
 */
import com.silkworm.common.ApplicationSessionRegistery;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionEvent implements HttpSessionListener {
    private final ApplicationSessionRegistery registery;

    /**
     * Creates a new instance of SessionEvent
     */
    public SessionEvent() {
        registery = ApplicationSessionRegistery.getInstance();
    }

    @Override
    public void sessionCreated(HttpSessionEvent event) {
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        registery.closeSession(event.getSession().getId(), false);
    }
}
