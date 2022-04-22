package designPattern.extend.dataObject;

import java.util.List;

/**
 * 描述:创建数据访问对象接口。
 *
 * @author WuYanchang
 * @date 2021/6/29 15:13
 */

public interface StudentDao {
    public List<Student> getAllStudents();

    public Student getStudent(int rollNo);

    public void updateStudent(Student student);

    public void deleteStudent(Student student);
}
