package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:业发放的奖金根据利润提成
 *
 * @author WuYanchang
 * @date 2021/8/2 9:23
 */

public class test12 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        double x = input.nextDouble();
        double y = 0;
        if (x > 0 && x <= 10) {
            y = x * 0.1;
        } else if (x > 10 && x <= 20) {
            y = 10 * 0.1 + (x - 10) * 0.075;
        } else if (x > 20 && x <= 40) {
            y = 10 * 0.1 + 10 * 0.075 + (x - 20) * 0.05;
        } else if (x > 40 && x <= 60) {
            y = 10 * 0.1 + 10 * 0.075 + 20 * 0.05 + (x - 40) * 0.03;
        } else if (x > 60 && x <= 100) {
            y = 10 * 0.1 + 10 * 0.075 + 20 * 0.05 + 20 * 0.03 + (x - 60) * 0.015;
        } else if (x > 100) {
            y = 10 * 0.1 + 10 * 0.075 + 20 * 0.05 + 20 * 0.03 + 40 * 0.015 + (x - 100) * 0.01;
        }
        System.out.println(y);
    }
}
