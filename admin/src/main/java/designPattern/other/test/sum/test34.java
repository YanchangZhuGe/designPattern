package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:按大小顺序输出
 *
 * @author WuYanchang
 * @date 2021/8/6 15:03
 */

public class test34 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int a = input.nextInt();
        int b = input.nextInt();
        int c = input.nextInt();
        System.out.println(a + "" + b + "" + c);
        if (a >
                b) {
            int t = a;
            a = b;
            b = t;
        }
        if (b >
                c) {
            int t = b;
            b = c;
            c = t;
        }
        if (a >
                b) {
            int t = a;
            a = b;
            b = t;
        }
        System.out.println(a + "" + b + "" + c);
    }
}
