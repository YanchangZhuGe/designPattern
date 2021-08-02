package designPattern.other.test.sum;

/**
 * 描述:且一个数字中无重复数字的三位
 *
 * @author WuYanchang
 * @date 2021/8/2 9:22
 */

public class test11 {
    public static void main(String[] args) {
        int count = 0;
        for (int i = 1; i < 5; i++) {
            for (int j = 1; j < 5; j++) {
                for (int k = 1; k < 5;
                     k++) {
                    if (i != j &&
                            j != k &&
                            i != k) {
                        count++;
                        System.out.println(i * 100 + j * 10 + k);
                    }
                }
            }
        }
        System.out.println(count);
    }
}
