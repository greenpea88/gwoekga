package com.gwoekga.server.datatype;

public class Recommend {
    private String id;
    private int postNo;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getPostNo() {
        return postNo;
    }

    public void setPostNo(int postNo) {
        this.postNo = postNo;
    }

    @Override
    public String toString() {
        return "Recommend{" +
                "id='" + id + '\'' +
                ", postNo=" + postNo +
                '}';
    }
}