package com.willy.example;

import com.willy.ratingbar.ScaleRatingBar;
import ohos.agp.components.BaseItemProvider;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.LayoutScatter;
import ohos.app.Context;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class MyAdapter extends BaseItemProvider {

    private final Context mContext;
    private final List<Integer> list;

    public MyAdapter(Context context) {
        mContext = context;
        list = new ArrayList<>();
        for (int index = 1; index < 20; index++) {
            list.add(index % 6);
        }
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public Object getItem(int position) {
        if (list != null && position >= 0 && position < list.size()) {
            return list.get(position);
        }
        return Optional.empty();
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public Component getComponent(int position, Component convertComponent, ComponentContainer componentContainer) {
        final Component cpt;
        if (convertComponent == null) {
            cpt = LayoutScatter.getInstance(mContext).parse(ResourceTable.Layout_item_ratingbar, null, false);
        } else {
            cpt = convertComponent;
        }
        ScaleRatingBar srb = (ScaleRatingBar) cpt.findComponentById(ResourceTable.Id_ratingBar);
        srb.setTag(position);
        srb.setRating(list.get(position));
        srb.setOnRatingChangeListener((ratingBar, rating, fromUser) -> {
            int pos = (int) ratingBar.getTag();
            list.set(pos, (int) rating);
        });
        return cpt;
    }
}
