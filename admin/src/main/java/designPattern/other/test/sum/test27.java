package designPattern.other.test.sum;

/**
 * 描述:求100之内的素数  …
 *
 * @author WuYanchang
 * @date 2021/8/3 15:30
 */

public class test27 {
    public static void main(String[] args) {
        System.out.println(2);
        boolean flag = true;
        for (int i = 3; i < 100; i += 2) {
            for (int j = 2; j <= Math.sqrt(i); j++) {
                if (i % j == 0) {
                    flag = false;
                    break;
                } else {
                    flag = true;
                }
            }
            if (flag == true) System.out.println(i);
        }
    }
}
