package designPattern.other.test.sum;

/**
 * 描述:素数
 *
 * @author WuYanchang
 * @date 2021/7/16 10:06
 */

public class test02 {
    public static void main(String[] args) {
        int count = 0;
        for (int i = 101; i < 200; i += 2) {
            boolean flag = true;
            for (int j = 2; j <= Math.sqrt(i); j++) {
                if (i % j == 0) {
                    flag = false;
                    break;
                }
            }
            if (flag == true) {
                count++;
                System.out.println(i);
            }
        }
        System.out.println(count);
    }
}
