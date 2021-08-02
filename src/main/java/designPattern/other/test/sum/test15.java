package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:由小到大输出
 *
 * @author WuYanchang
 * @date 2021/8/2 9:25
 */

public class test15 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int x = input.nextInt();
        int y = input.nextInt();
        int z = input.nextInt();
        int t = 0;
        if (x > y) {
            t = x;
            x = y;
            y = t;
        }
        if (y >
                z) {
            t = z;
            z = y;
            y = t;
        }
        if (x > y) {
            t = x;
            x = y;
            y = t;
        }
        System.out.println(x + "" + y + "" + z);
    }
}
