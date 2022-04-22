package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/29 16:51
 */

public class test08 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int a = input.nextInt();
        int n = input.nextInt();
        int sum = 0, b = 0;
        for (int i = 0; i < n; i++) {
            b += a;
            sum += b;
            a = a * 10;
        }
        System.out.println(sum);
    }
}
