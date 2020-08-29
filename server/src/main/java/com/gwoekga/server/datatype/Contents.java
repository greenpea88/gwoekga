package com.gwoekga.server.datatype;

public class Contents {
    private int contentsSeq;
    private String title;
    private String explanation;
    private String linkUrl;
    private String category;
    private String posterUrl;

    public int getContentsSeq() {
        return contentsSeq;
    }

    public void setContentsSeq(int contentsSeq) {
        this.contentsSeq = contentsSeq;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    @Override
    public String toString() {
        return "Contents{" +
                "contentsNo=" + contentsSeq +
                ", title='" + title + '\'' +
                ", explanation='" + explanation + '\'' +
                ", linkUrl='" + linkUrl + '\'' +
                ", category='" + category + '\'' +
                ", posterUrl='" + posterUrl + '\'' +
                '}';
    }
}
