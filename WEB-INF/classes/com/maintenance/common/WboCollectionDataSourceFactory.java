
package com.maintenance.common;

import java.util.Collection;
import net.sf.jasperreports.engine.*;

public class WboCollectionDataSourceFactory {

    public WboCollectionDataSourceFactory() {

    }

    public WboCollectionDataSourceFactory(Collection data) {
        WboCollectionDataSourceFactory.data = data;
    }

    private static Collection data = null;
    
    public static JRDataSource createDataSource() {
        return new WboCollectionDataSource(WboCollectionDataSourceFactory.data);
    }

}
