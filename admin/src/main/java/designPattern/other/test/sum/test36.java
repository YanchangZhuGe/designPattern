package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:其前面各数顺序向后移
 *
 * @author WuYanchang
 * @date 2021/8/10 19:29
 */

public class test36 {
    public static void main(String[] args) {
        int N = 10;
        int M = 3;
        Scanner input = new Scanner(System.in);
        int[] a = new int[N];
        for (int i = 0; i < N; i++) {
            a[i] = input.nextInt();
        }
        for (int i = 0; i < a.length; i++) {
            System.out.println(a[i]);
        }
        int[] b = new int[M];
        for (int i = 0; i < M; i++) {
            b[i] = a[N - M + i];
        }
        for (int i = N - 1; i >= M;
             i--) {
            a[i] = a[i - M];
        }
        for (int i = 0; i < M; i++) {
            a[i] = b[i];
        }
        System.out.println("");
        for (int i = 0; i < N; i++) {
            System.out.println(a[i]);
        }
    }
}
