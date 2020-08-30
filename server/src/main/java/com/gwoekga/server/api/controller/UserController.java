package com.gwoekga.server.api.controller;

import com.gwoekga.server.bo.UserBO;
import com.gwoekga.server.datatype.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.websocket.server.PathParam;
import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController extends AbstractController{

    @Autowired
    UserBO userBO;

    @RequestMapping("/all")
    @ResponseBody
    public List<User> selectUsers(){
        return userBO.getUserList();
    }

    @RequestMapping("/{id}")
    @ResponseBody
    public User selectUsers(@PathVariable String id){
        return userBO.getUser(id);
    }
}
