package com.gwoekga.server.dao;

import com.gwoekga.server.datatype.Category;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class CategoryDAO extends DataBaseDAO{

    public List<Category> getCategories(){
        List<Map<String, Object>> resultList = sqlSession.selectList("category.selectCategories");
        List<Category> categories = new ArrayList<>();
        for(Map<String, Object> result : resultList){
            categories.add(Category.fromMap(result));
        }
        return categories;
    }
}
