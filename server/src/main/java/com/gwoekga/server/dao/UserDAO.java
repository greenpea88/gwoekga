package com.gwoekga.server.dao;

import com.gwoekga.server.datatype.User;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class UserDAO extends DataBaseDAO{

    public List<User> getUserList(){
        List<Map<String, Object>> resultList = sqlSession.selectList("user.selectUsers");
        List<User> userList = new ArrayList<>();
        for(Map<String, Object> result : resultList){
            userList.add(User.fromMap(result));
        }
        return userList;
    }

    public User getUser(String id){
        Map<String, Object> result = sqlSession.selectOne("user.selectUser", id);
        return User.fromMap(result);
    }


}
