package designPattern.extend.mvc;

/**
 * 描述:使用 StudentController 方法来演示 MVC 设计模式的用法。
 *
 * @author WuYanchang
 * @date 2021/6/25 17:29
 */

public class MVCPatternDemo {
    public static void main(String[] args) {

        //从数据库获取学生记录
        Student model = retrieveStudentFromDatabase();

        //创建一个视图：把学生详细信息输出到控制台
        StudentView view = new StudentView();

        StudentController controller = new StudentController(model, view);

        controller.updateView();

        //更新模型数据
        controller.setStudentName("John");

        controller.updateView();
    }

    private static Student retrieveStudentFromDatabase() {
        Student student = new Student();
        student.setName("Robert");
        student.setRollNo("10");
        return student;
    }
}
