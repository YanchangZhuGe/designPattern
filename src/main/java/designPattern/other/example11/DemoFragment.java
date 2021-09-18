package com.willy.example;

import com.willy.ratingbar.BaseRatingBar;
import com.willy.ratingbar.RotationRatingBar;
import com.willy.ratingbar.ScaleRatingBar;
import ohos.agp.components.Button;
import ohos.agp.components.Component;
import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.LayoutScatter;
import ohos.agp.window.dialog.ToastDialog;
import ohos.app.Context;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;

public class DemoFragment extends DirectionalLayout {

    private boolean isFlag = true;

    public DemoFragment(Context context) {
        super(context);
        DirectionalLayout layout = (DirectionalLayout) LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_demo_fragment, null, false);
        addComponent(layout);
        BaseRatingBar baseRatingBar = (BaseRatingBar) layout.findComponentById(ResourceTable.Id_baseratingbar_main);
        baseRatingBar.setClearRatingEnabled(false);
        ScaleRatingBar scaleRatingBar = (ScaleRatingBar) layout.findComponentById(ResourceTable.Id_scaleRatingBar);
        RotationRatingBar rotationRatingBar = (RotationRatingBar) layout.findComponentById(ResourceTable.Id_rotationratingbar_main);
        baseRatingBar.setOnRatingChangeListener(new BaseRatingBar.OnRatingChangeListener() {
            @Override
            public void onRatingChange(BaseRatingBar ratingBar, float rating, boolean fromUser) {
                System.out.println(rating);
            }
        });
        scaleRatingBar.setOnRatingChangeListener(new BaseRatingBar.OnRatingChangeListener() {
            @Override
            public void onRatingChange(BaseRatingBar ratingBar, float rating, boolean fromUser) {
                System.out.println(rating);
            }
        });
        rotationRatingBar.setOnRatingChangeListener(new BaseRatingBar.OnRatingChangeListener() {
            @Override
            public void onRatingChange(BaseRatingBar ratingBar, float rating, boolean fromUser) {
                System.out.println(rating);
            }
        });
        Button addRatingButton = (Button) layout.findComponentById(ResourceTable.Id_button_main_add_rating);
        addRatingButton.setClickedListener(v -> {
            if (isFlag){
                isFlag = false;
                float currentRating = baseRatingBar.getRating();
                baseRatingBar.setRating(currentRating + 0.25f);
                currentRating = scaleRatingBar.getRating();
                scaleRatingBar.setRating(currentRating + 0.25f);
                currentRating = rotationRatingBar.getRating();
                rotationRatingBar.setRating(currentRating + 0.25f);
                context.getUITaskDispatcher().delayDispatch(() -> {
                    isFlag = true;
                }, 700);
            }
        });
    }
}
