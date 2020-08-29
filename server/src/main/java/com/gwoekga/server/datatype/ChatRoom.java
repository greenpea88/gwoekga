package com.gwoekga.server.datatype;

public class ChatRoom {
    private int pk;
    private int roomSeq;
    private String username;

    public int getPk() {
        return pk;
    }

    public void setPk(int pk) {
        this.pk = pk;
    }

    public int getRoomSeq() {
        return roomSeq;
    }

    public void setRoomSeq(int roomSeq) {
        this.roomSeq = roomSeq;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public String toString() {
        return "ChatRoom{" +
                "pk=" + pk +
                ", roomNo=" + roomSeq +
                ", username='" + username + '\'' +
                '}';
    }
}