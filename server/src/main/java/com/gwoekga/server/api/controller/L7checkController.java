package com.gwoekga.server.api.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class L7checkController extends AbstractController {

    @RequestMapping("/l7check")
    @ResponseBody
    public String l7check(){
        return "OK";
    }

}
