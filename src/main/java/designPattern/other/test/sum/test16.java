package designPattern.other.test.sum;

/**
 * 描述:输出9*9口诀。
 *
 * @author WuYanchang
 * @date 2021/8/3 13:59
 */

public class test16 {
    public static void main(String[] args) {
        for (int i = 1; i < 10; i++) {
            for (int j = 1; j <= i; j++) {
                System.out.print(i + "*" + j + "=" + i * j);
                System.out.print(" ");
            }
            System.out.println("");
        }
    }
}
