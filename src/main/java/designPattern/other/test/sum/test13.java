package designPattern.other.test.sum;

/**
 * 描述:一个整
 *
 * @author WuYanchang
 * @date 2021/8/2 9:23
 */

public class test13 {
    public static void main(String[] args) {
        for (int i = -100; i < 10000; i++) {
            if (Math.sqrt(i + 100) % 1 == 0 &&
                    Math.sqrt(i + 268) % 1 == 0) {
                System.out.println(i);
            }
        }
    }
}
