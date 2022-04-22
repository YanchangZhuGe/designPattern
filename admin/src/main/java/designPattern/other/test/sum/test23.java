package designPattern.other.test.sum;

/**
 * 描述:问第五个人多少岁
 *
 * @author WuYanchang
 * @date 2021/8/3 15:26
 */

public class test23 {
    public static void main(String[] args) {
        int age = 10;
        for (int i = 2; i <= 5; i++) {
            age += 2;
        }
        System.out.println(age);
    }
}
