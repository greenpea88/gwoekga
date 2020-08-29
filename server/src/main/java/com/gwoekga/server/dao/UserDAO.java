package com.gwoekga.server.dao;

import com.gwoekga.server.datatype.User;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class UserDAO {

    public List<User> getUserList(){
        List<User> users = new ArrayList<>();
        users.add(new User("id1", "pw1", "abc@abc.com"));
        return users;
    }

    public User getUser(String id){
        return new User("id1", "pw1", "abc@abc.com");
    }


}
