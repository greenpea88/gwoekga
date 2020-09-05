package com.gwoekga.server.datatype;

import java.util.Map;

public class Category {

    private String categoryEng;
    private String categoryKr;
    private int seq;

    public Category(String categoryEng, String categoryKr, int seq) {
        this.categoryEng = categoryEng;
        this.categoryKr = categoryKr;
        this.seq = seq;
    }

    public String getCategoryEng() {
        return categoryEng;
    }

    public void setCategoryEng(String categoryEng) {
        this.categoryEng = categoryEng;
    }

    public String getCategoryKr() {
        return categoryKr;
    }

    public void setCategoryKr(String categoryKr) {
        this.categoryKr = categoryKr;
    }

    public int getSeq() {
        return seq;
    }

    public void setSeq(int seq) {
        this.seq = seq;
    }

    @Override
    public String toString() {
        return "Category{" +
                "categoryNumber='" + categoryEng + '\'' +
                ", categoryName='" + categoryKr + '\'' +
                ", seq=" + seq +
                '}';
    }

    public static Category fromMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }
        String categoryNumber = (String) map.get("categoryNumber");
        String categoryName = (String) map.get("categoryName");
        int seq = (int)map.get("seq");
        return new Category(categoryNumber, categoryName, seq);
    }


}
