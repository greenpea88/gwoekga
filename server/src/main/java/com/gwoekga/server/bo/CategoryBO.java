package com.gwoekga.server.bo;

import com.gwoekga.server.dao.CategoryDAO;
import com.gwoekga.server.datatype.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryBO {

    @Autowired
    CategoryDAO categoryDAO;
    public List<Category> getCategories() {
        return categoryDAO.getCategories();
    }
}
