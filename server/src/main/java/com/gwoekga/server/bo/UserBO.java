package com.gwoekga.server.bo;

import com.gwoekga.server.dao.UserDAO;
import com.gwoekga.server.datatype.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserBO {

    @Autowired
    private UserDAO userDAO;

    public List<User> getUserList(){
        return userDAO.getUserList();
    }

    public User getUser(String id){
        return userDAO.getUser(id);
    }
}
