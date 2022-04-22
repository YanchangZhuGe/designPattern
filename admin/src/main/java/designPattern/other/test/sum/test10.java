package designPattern.other.test.sum;

/**
 * 描述:高度自由落下
 *
 * @author WuYanchang
 * @date 2021/8/2 9:21
 */

public class test10 {
    public static void main(String[] args) {
        double h = 100;
        double s = 100;
        for (int i = 1; i <= 10; i++) {
            h = h / 2;
            s = s + 2 * h;
        }
        System.out.println(s);
        System.out.println(h);
    }
}
