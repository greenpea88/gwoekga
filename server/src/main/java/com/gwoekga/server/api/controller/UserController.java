package com.gwoekga.server.api.controller;

import com.gwoekga.server.bo.UserBO;
import com.gwoekga.server.datatype.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UserController extends AbstractController{

    @Autowired
    UserBO userBO;

    @RequestMapping("/users")
    @ResponseBody
    public List<User> selectUsers(){
        return userBO.getUserList();
    }
}
