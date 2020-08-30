package com.gwoekga.server.datatype;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

public class User {
    public static Logger logger = LoggerFactory.getLogger(User.class);
    private String id;
    private String pw;
    private String email;

    private User() {

    }

    public User(String id, String pw, String email) {
        this.id = id;
        this.pw = pw;
        this.email = email;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", pw='" + pw + '\'' +
                ", email='" + email + '\'' +
                '}';
    }

    public static User fromMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }
        String id = (String) map.get("id");
        String pw = (String) map.get("pw");
        String email = (String) map.get("email");
        return new User(id, pw, email);
    }
}
