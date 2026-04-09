
package com.maintenance.common;

import java.util.Date;

public class ResultDataReportBean {
    private String unitId;
    private String unitNo;
    private String unitName;
    private String issueId;
    private String jobOrderNo;
    private String jobOrderDate;
    private String mainCatId;
    private String mainCatName;
    private String modelId;
    private String modelName;
    private String schId;
    private String schTitle;
    private int schFrec;
    private String schFrecType;
    private int readingTravel;
    private int readingJobOrder;
    private int lastReadingMachine;
    private int currReading;
    private int prvReading;
    private int diffReading;
    private int distance;
    private String branchName;
    private Date currentReadingDate;
    private Date prvReadingDate;
    private int whichCloser;
    private int maintenanceDue;

    public String getUnitId() {
        return unitId;
    }

    public void setUnitId(String unitId) {
        this.unitId = unitId;
    }

    public String getUnitNo() {
        return unitNo;
    }

    public void setUnitNo(String unitNo) {
        this.unitNo = unitNo;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public String getJobOrderNo() {
        return jobOrderNo;
    }

    public void setJobOrderNo(String jobOrderNo) {
        this.jobOrderNo = jobOrderNo;
    }

    public String getJobOrderDate() {
        return jobOrderDate;
    }

    public void setJobOrderDate(String jobOrderDate) {
        this.jobOrderDate = jobOrderDate;
    }

    public String getMainCatId() {
        return mainCatId;
    }

    public void setMainCatId(String mainCatId) {
        this.mainCatId = mainCatId;
    }

    public String getMainCatName() {
        return mainCatName;
    }

    public void setMainCatName(String mainCatName) {
        this.mainCatName = mainCatName;
    }

    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getSchId() {
        return schId;
    }

    public void setSchId(String schId) {
        this.schId = schId;
    }

    public String getSchTitle() {
        return schTitle;
    }

    public void setSchTitle(String schTitle) {
        this.schTitle = schTitle;
    }

    public int getCurrReading() {
        return currReading;
    }

    public void setCurrReading(int currReading) {
        this.currReading = currReading;
    }

    public int getPrvReading() {
        return prvReading;
    }

    public void setPrvReading(int prvReading) {
        this.prvReading = prvReading;
    }

    public int getDiffReading() {
        return diffReading;
    }

    public void setDiffReading(int diffReading) {
        this.diffReading = diffReading;
    }

    public String getIssueId() {
        return issueId;
    }

    public void setIssueId(String issueId) {
        this.issueId = issueId;
    }

    public int getDistance() {
        return distance;
    }

    public void setDistance(int distance) {
        this.distance = distance;
    }

    public int getSchFrec() {
        return schFrec;
    }

    public void setSchFrec(int schFrec) {
        this.schFrec = schFrec;
    }

    public String getSchFrecType() {
        return schFrecType;
    }

    public void setSchFrecType(String schFrecType) {
        this.schFrecType = schFrecType;
    }

    public int getReadingJobOrder() {
        return readingJobOrder;
    }

    public void setReadingJobOrder(int readingJobOrder) {
        this.readingJobOrder = readingJobOrder;
    }

    public int getLastReadingMachine() {
        return lastReadingMachine;
    }

    public void setLastReadingMachine(int lastReadingMachine) {
        this.lastReadingMachine = lastReadingMachine;
    }

    public int getReadingTravel() {
        return readingTravel;
    }

    public void setReadingTravel(int readingTravel) {
        this.readingTravel = readingTravel;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public Date getCurrentReadingDate() {
        return currentReadingDate;
    }

    public void setCurrentReadingDate(Date currentReadingDate) {
        this.currentReadingDate = currentReadingDate;
    }

    public Date getPrvReadingDate() {
        return prvReadingDate;
    }

    public void setPrvReadingDate(Date prvReadingDate) {
        this.prvReadingDate = prvReadingDate;
    }

    public int getWhichCloser() {
        return whichCloser;
    }

    public void setWhichCloser(int whichCloser) {
        this.whichCloser = whichCloser;
    }

    public int getMaintenanceDue() {
        return maintenanceDue;
    }

    public void setMaintenanceDue(int maintenanceDue) {
        this.maintenanceDue = maintenanceDue;
    }
    
}
