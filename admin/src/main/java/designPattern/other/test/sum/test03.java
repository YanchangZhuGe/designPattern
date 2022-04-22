package designPattern.other.test.sum;

/**
 * 描述:水仙花数
 *
 * @author WuYanchang
 * @date 2021/7/19 11:01
 */

public class test03 {
    public static void main(String[] args) {
        int a, b, c;
        for (int i = 101; i < 1000; i++) {
            a = i % 10;
            b = i / 10 % 10;
            c = i / 100;
            if (a * a * a + b * b * b + c * c * c == i) {
                System.out.println(i);
            }
        }
    }

}
