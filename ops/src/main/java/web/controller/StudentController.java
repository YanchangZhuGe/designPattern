package web.controller;

import com.gv.ops.web.entity.Student;
import com.gv.ops.web.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/28 14:10
 */

@RestController
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @Value("${text.success}")
    private String port;

    @GetMapping("/get")
    public String textGet(){
        return "success get " + port;
    }

    @PostMapping(("/post"))
    public String textPost(){
        return "success post" + port;
    }

    @GetMapping("/list")
    public List<Student> list(){
        List<Student> list = studentService.list();
        return list;
    }
}
