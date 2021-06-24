package designPattern.structural.adapter;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/1 19:46
 */

public class VlcPlayer implements AdvancedMediaPlayer{
    @Override
    public void playVlc(String fileName) {
        System.out.println("Playing vlc file. Name: "+ fileName);
    }

    @Override
    public void playMp4(String fileName) {
        //什么也不做
    }
}
