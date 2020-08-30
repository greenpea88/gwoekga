package com.gwoekga.server.api.controller;

import com.gwoekga.server.datatype.Contents;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@RequestMapping("/contensts")
public class ContentsController extends AbstractController{

    @RequestMapping("/all")
    @ResponseBody
    public List<Contents> getContents(){
        return null;
    }
}
