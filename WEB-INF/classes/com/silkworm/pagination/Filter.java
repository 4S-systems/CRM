package com.silkworm.pagination;

import java.util.ArrayList;
import java.util.List;

public class Filter {

    public Filter() {
        this(null);
    }

    public Filter(List<FilterCondition> conditions) {
        this(PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE, conditions);
    }

    public Filter(short countRowPage, List<FilterCondition> conditions) {
        this((short) 0, countRowPage, conditions);
    }

    public Filter(short pageIndex, short countRowPage, List<FilterCondition> conditions) {
        this.pageIndex = pageIndex;
        this.countRowPage = countRowPage;
        this.conditions = (conditions != null) ? conditions : new ArrayList<FilterCondition>(0);
    }

    public short getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(short pageIndex) {
        this.pageIndex = pageIndex;
    }

    public short getCountRowPage() {
        return countRowPage;
    }

    public void setCountRowPage(short countRowPage) {
        this.countRowPage = countRowPage;
    }

    public void setConditions(List<FilterCondition> conditions) {
        this.conditions = conditions;
    }

    public List<FilterCondition> getConditions() {
        return conditions;
    }

    public long getCountResult() {
        return countResult;
    }

    public void setCountResult(long countResult) {
        this.countResult = countResult;
        try {
            numberPages = (short) (this.countResult / this.countRowPage);

            if((this.countResult % this.countRowPage) > 0) {
                numberPages++;
            }
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public Short getStartIndex() {
        return new Short((short) ((pageIndex * countRowPage) + 1));
    }

    public Short getEndIndex() {
        return new Short((short) ((pageIndex * countRowPage) + countRowPage));
    }

    public short getStartPage() {
        short start = (short) (pageIndex - 5);
        return (start > 0) ? start : 0;
    }

    public short getEndPage() {
        short end = (short) (pageIndex + 5);
        return (end < getNumberPages()) ? end : getNumberPages();
    }

    public boolean canNext() {
        return (pageIndex < getNumberPages()) ? true : false;
    }

    public boolean canPrevious() {
        return (pageIndex > 1) ? true : false;
    }

    /**
     * @return the numberPages
     */
    public short getNumberPages() {
        return numberPages;
    }
    
    private short pageIndex;
    private short countRowPage;
    private long countResult;
    private short numberPages;
    private List<FilterCondition> conditions;

    
}
