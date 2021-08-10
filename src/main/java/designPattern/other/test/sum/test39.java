package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:写一个函数，输入n为偶数时，调用函数求
 *
 * @author WuYanchang
 * @date 2021/8/10 19:31
 */

public class test39 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int n = input.nextInt();
        System.out.println(sum(n));
    }

    public static double sum(int n) {
        double sum = 0;
        if (n % 2 == 0) {
            for (int i = 2; i <= n; i += 2) {
                sum += (double) 1 / i;
            }
        } else {
            for (int i = 1; i <= n; i += 2) {
                sum += (double) 1 / i;
            }
        }
        return sum;
    }
}
