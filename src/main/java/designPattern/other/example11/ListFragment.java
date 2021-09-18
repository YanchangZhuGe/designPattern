package com.willy.example;

import ohos.agp.components.DirectionalLayout;
import ohos.agp.components.LayoutScatter;
import ohos.agp.components.ListContainer;
import ohos.app.Context;

public class ListFragment extends DirectionalLayout {

    public ListFragment(Context context) {
        super(context);
        DirectionalLayout layout = (DirectionalLayout) LayoutScatter.getInstance(context)
                .parse(ResourceTable.Layout_fragment_list, null, false);
        addComponent(layout);

        ListContainer recyclerView = (ListContainer) layout.findComponentById(ResourceTable.Id_recyclerView);
        recyclerView.setItemProvider(new MyAdapter(getContext()));
    }
}
