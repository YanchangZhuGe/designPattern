package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:最大公约数和最小公倍数
 *
 * @author WuYanchang
 * @date 2021/7/29 16:50
 */

public class test06 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int a = input.nextInt();
        int b = input.nextInt();
        test06 test = new test06();
        int i = test.gongyinshu(a, b);
        System.out.println("最小公因数" + i);
        System.out.println("最大公倍数" + a * b / i);
    }

    public int gongyinshu(int a, int b) {
        if (a <
                b) {
            int t = b;
            b = a;
            a = t;
        }
        while (b != 0) {
            if (a == b) {
                return a;
            }
            int x = b;
            b = a % b;
            a = x;
        }
        return a;
    }
}
