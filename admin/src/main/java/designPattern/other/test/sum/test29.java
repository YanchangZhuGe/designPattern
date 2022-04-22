package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:求一个3*3矩阵对角线元素之和
 *
 * @author WuYanchang
 * @date 2021/8/3 15:31
 */

public class test29 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[][] a = new int[3][3];
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                a[i][j] = input.nextInt();
            }
        }
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                System.out.print(a[i][j]);
            }
            System.out.println("");
        }
        int sum = 0;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (i == j) {
                    sum += a[i][j];
                }
            }
        }
        System.out.println(sum);
    }
}
