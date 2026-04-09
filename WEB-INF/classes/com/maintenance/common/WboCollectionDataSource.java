package com.maintenance.common;

import com.silkworm.business_objects.WebBusinessObject;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRField;
import net.sf.jasperreports.engine.JRRewindableDataSource;

public class WboCollectionDataSource implements JRRewindableDataSource {

    private Collection data = null;
    private Iterator iterator = null;
    private Map currentMap = null;

    public WboCollectionDataSource(Collection data) {
        this.data = data;
        if (this.data != null) {
            this.iterator = this.data.iterator();
        }
    }

    public boolean next() throws JRException {
        try {
            boolean hasNext = false;
            if (this.iterator != null) {
                hasNext = this.iterator.hasNext();
                if (hasNext) {
                    Object currentObject = this.iterator.next();
                    if (currentObject instanceof WebBusinessObject) {
                        this.currentMap = ((WebBusinessObject)currentObject).getContents();
                    } else {
                        throw new JRException("Non-WBO (" +
                        currentObject.getClass() + ") found in collection");
                    }
                }
            }
            return hasNext;
        } catch (Exception exception) {
            throw new JRException(exception);
        }
    }

    public Object getFieldValue(JRField jrField) throws JRException {
        try {
            String fieldName = jrField.getName();
            if (currentMap != null) {
                return currentMap.get(fieldName);
            } else {
                throw new JRException("Field " + fieldName + " not found in Map");
            }
        } catch (Exception exception) {
            throw new JRException(exception);
        }
    }

    public void moveFirst() throws JRException {
        this.iterator = this.data.iterator();
    }

}