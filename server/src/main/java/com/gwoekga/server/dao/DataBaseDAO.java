package com.gwoekga.server.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class DataBaseDAO {
    protected Logger logger = LoggerFactory.getLogger(DataBaseDAO.class);

    @Autowired
    protected SqlSessionTemplate sqlSession;

}
