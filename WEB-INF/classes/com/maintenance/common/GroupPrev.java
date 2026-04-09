
package com.maintenance.common;


public class GroupPrev {

    private  String userId;
    private  boolean close = false;
    private  boolean finish = false;
    private  boolean forward = false;
    private  boolean bookmark = false;
    private  boolean comment = false;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    /**
     * @return the close
     */
    public boolean getClose() {
        return close;
    }

    /**
     * @param close the close to set
     */
    public void setClose(boolean close) {
        this.close = close;
    }

    /**
     * @return the finish
     */
    public boolean getFinish() {
        return finish;
    }

    /**
     * @param finish the finish to set
     */
    public void setFinish(boolean finish) {
        this.finish = finish;
    }

    /**
     * @return the forward
     */
    public boolean getForward() {
        return forward;
    }

    /**
     * @param forward the forward to set
     */
    public void setForward(boolean forward) {
        this.forward = forward;
    }

    /**
     * @return the bookmark
     */
    public boolean getBookmark() {
        return bookmark;
    }

    /**
     * @param bookmark the bookmark to set
     */
    public void setBookmark(boolean bookmark) {
        this.bookmark = bookmark;
    }

    /**
     * @return the comment
     */
    public boolean getComment() {
        return comment;
    }

    /**
     * @param comment the comment to set
     */
    public void setComment(boolean comment) {
        this.comment = comment;
    }

   
}
