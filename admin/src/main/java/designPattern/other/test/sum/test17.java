package designPattern.other.test.sum;

/**
 * 描述:猴子吃桃问题
 *
 * @author WuYanchang
 * @date 2021/8/3 14:39
 */

public class test17 {
    public static void main(String[] args) {
        int x = 1;
        for (int i = 10; i > 1;
             i--) {
            x = (x + 1) * 2;
        }
        System.out.println(x);
    }
}
