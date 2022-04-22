package designPattern.other.test.sum;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/29 16:53
 */

public class test09 {
    public static void main(String[] args) {
        for (int i = 1; i <= 1000; i++) {
            int t = 0;
            for (int j = 1; j <= i / 2; j++) {
                if (i % j == 0) {
                    t += j;
                }
            }
            if (t == i) {
                System.out.println(i);
            }
        }
    }
}
