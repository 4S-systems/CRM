package com.customization.common;

public class CustomizeEquipmentMgr extends CustomizeMgr {

    public static CustomizeEquipmentMgr getInstance() {
        if(customizeEquipmentMgr == null) {
            customizeEquipmentMgr = new CustomizeEquipmentMgr();
        }
        return customizeEquipmentMgr;
    }

    private CustomizeEquipmentMgr(){
        super("classes" + FILE_SEPARATOR + "com" + FILE_SEPARATOR + "customization" + FILE_SEPARATOR + "xml" + FILE_SEPARATOR + "customization_equipment.xml");
    }

    private static CustomizeEquipmentMgr customizeEquipmentMgr = null;
    public static final String PRODUCTION_LINE_ELEMENT = "ProductionLine";
}
