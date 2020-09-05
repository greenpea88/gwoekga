package com.gwoekga.server.api.controller;

import com.gwoekga.server.bo.CategoryBO;
import com.gwoekga.server.datatype.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/category")
public class CategoryController {

    @Autowired
    CategoryBO categoryBO;

    @RequestMapping("/all")
    @ResponseBody
    public List<Category> getCategoris(){
        return categoryBO.getCategories();
    }


}
