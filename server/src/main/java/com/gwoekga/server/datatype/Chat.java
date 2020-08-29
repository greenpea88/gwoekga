package com.gwoekga.server.datatype;

public class Chat {
    private int chatSeq;
    private ChatRoom chatRoom;
    private String comment;

    public int getChatSeq() {
        return chatSeq;
    }

    public void setChatSeq(int chatSeq) {
        this.chatSeq = chatSeq;
    }

    public ChatRoom getChatRoom() {
        return chatRoom;
    }

    public void setChatRoom(ChatRoom chatRoom) {
        this.chatRoom = chatRoom;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    @Override
    public String toString() {
        return "Chat{" +
                "chatSeq=" + chatSeq +
                ", chatRoom=" + chatRoom +
                ", comment='" + comment + '\'' +
                '}';
    }
}
