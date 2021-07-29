package designPattern.other.test.sum;

import java.util.Scanner;

/**
 * 描述:运算符的嵌套
 *
 * @author WuYanchang
 * @date 2021/7/29 14:18
 */

public class test05 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int score = input.nextInt();
        char grade = score >= 90 ? 'A' : score >= 60 ? 'B' : 'C';
        System.out.println(grade);
    }
}
