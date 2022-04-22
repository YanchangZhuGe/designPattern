package designPattern.other.test.sum;

/**
 * 描述:菲波拉契数列
 *
 * @author WuYanchang
 * @date 2021/7/16 10:03
 */

public class test01 {
    public static void main(String[] args) {
        int f1 = 1, f2 = 1, f;
        int M = 30;
        System.out.println(f1);
        System.out.println(f2);
        for (int i = 3; i < M; i++) {
            f = f2;
            f2 = f1 + f2;
            f1 = f;
            System.out.println(f2);
        }
    }
}
