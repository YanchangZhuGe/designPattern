package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:逆序输出。
 *
 * @author WuYanchang
 * @date 2021/8/6 14:48
 */

public class test31 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] a = new int[20];
        int i = 0;
        do {
            a[i] = input.nextInt();
            i++;
        } while (a[i - 1] != -1);
        for (int j = 0; j < i - 1; j++) {
            System.out.println(a[j]);
        }
        for (int k = i - 1; k > 0;
             k--) {
            System.out.println(a[k - 1]);
        }
    }
}
