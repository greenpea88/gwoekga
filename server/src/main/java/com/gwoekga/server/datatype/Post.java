package com.gwoekga.server.datatype;

public class Post {
    private int postSeq;
    private String Written;
    private double star;
    private int recommend;
    private User user;
    private Contents contents;

    public int getPostSeq() {
        return postSeq;
    }

    public void setPostSeq(int postSeq) {
        this.postSeq = postSeq;
    }

    public String getWritten() {
        return Written;
    }

    public void setWritten(String written) {
        Written = written;
    }

    public double getStar() {
        return star;
    }

    public void setStar(double star) {
        this.star = star;
    }

    public int getRecommend() {
        return recommend;
    }

    public void setRecommend(int recommend) {
        this.recommend = recommend;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Contents getContents() {
        return contents;
    }

    public void setContents(Contents contents) {
        this.contents = contents;
    }

    @Override
    public String toString() {
        return "Post{" +
                "postSeq=" + postSeq +
                ", Written='" + Written + '\'' +
                ", star=" + star +
                ", recommend=" + recommend +
                ", user=" + user +
                ", contents=" + contents +
                '}';
    }
}
