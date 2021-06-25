package designPattern.extend.mvc;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 17:28
 */

public class StudentView {
    public void printStudentDetails(String studentName, String studentRollNo){
        System.out.println("Student: ");
        System.out.println("Name: " + studentName);
        System.out.println("Roll No: " + studentRollNo);
    }
}
