/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.willy.example.slice;

import com.willy.example.DemoFragment;
import com.willy.example.ListFragment;
import com.willy.example.ResourceTable;
import com.willy.ratingbar.TouchEventManager;
import ohos.aafwk.ability.AbilitySlice;
import ohos.aafwk.content.Intent;
import ohos.agp.components.Component;
import ohos.agp.components.ComponentContainer;
import ohos.agp.components.PageSlider;
import ohos.agp.components.PageSliderProvider;
import ohos.agp.components.StackLayout;
import ohos.agp.components.TabList;
import ohos.agp.utils.Color;
import ohos.agp.window.service.WindowManager;
import ohos.app.Context;
import ohos.eventhandler.EventHandler;
import ohos.eventhandler.EventRunner;

/** MainAbilitySlice
 *
 * @author ljx
 * @since 2021-07-02
 */
public class MainAbilitySlice extends AbilitySlice {

    private PageSlider pageSlider;
    private TabList tabList;
    private Context mContext;
    private static DemoFragment demoFragment;
    private static ListFragment listFragment;

    @Override
    public void onStart(Intent intent) {
        super.onStart(intent);
        WindowManager.getInstance().getTopWindow().get().setStatusBarColor(new Color(Color.getIntColor("#3F51B5")).getValue());
        super.setUIContent(ResourceTable.Layout_ability_main);
        mContext = getContext();
        initTabList();
        initPageSlider();
    }

    private void initTabList() {
        tabList = (TabList) findComponentById(ResourceTable.Id_tab_list);
        TabList.Tab tab = tabList.new Tab(getContext());
        tab.setText("ANIMATION DEMO");
        tabList.addTab(tab);
        TabList.Tab tab2 = tabList.new Tab(getContext());
        tab2.setText("RECYCLERVIEW DEMO");
        tabList.addTab(tab2);
        tabList.setFixedMode(true);
        tab.select();
        tabList.addTabSelectedListener(new TabList.TabSelectedListener() {
            @Override
            public void onSelected(TabList.Tab tab) {
                int position = tab.getPosition();
                pageSlider.setCurrentPage(position);
            }

            @Override
            public void onUnselected(TabList.Tab tab) {

            }

            @Override
            public void onReselected(TabList.Tab tab) {

            }
        });
    }

    private void initPageSlider() {
        demoFragment = new DemoFragment(mContext);
        demoFragment.setLayoutConfig(
                new StackLayout.LayoutConfig(
                        ComponentContainer.LayoutConfig.MATCH_PARENT,
                        ComponentContainer.LayoutConfig.MATCH_PARENT));
        listFragment = new ListFragment(mContext);
        listFragment.setLayoutConfig(
                new StackLayout.LayoutConfig(
                        ComponentContainer.LayoutConfig.MATCH_PARENT,
                        ComponentContainer.LayoutConfig.MATCH_PARENT));

        pageSlider = (PageSlider) findComponentById(ResourceTable.Id_page_slider);
        pageSlider.setProvider(new MyPagerProvider());
        pageSlider.setEnabled(false);
        pageSlider.addPageChangedListener(new PageSlider.PageChangedListener() {
            @Override
            public void onPageSliding(int itemPos, float itemPosOffset, int itemPosPixles) {

            }

            @Override
            public void onPageSlideStateChanged(int state) {

            }

            @Override
            public void onPageChosen(int itemPos) {
                tabList.selectTabAt(itemPos);
            }
        });

        TouchEventManager.getInstance().setResultCallback(new TouchEventManager.TouchEventCallback() {

            @Override
            public void onTouch() {
                pageSlider.setEnabled(false);
            }

            @Override
            public void onCancel() {
                EventRunner runner = EventRunner.create(true);
                EventHandler mHandler = new EventHandler(runner);
                mHandler.postTask(new Runnable() {
                    @Override
                    public void run() {
                        pageSlider.setEnabled(true);
                    }
                }, 600, EventHandler.Priority.IMMEDIATE);
            }
        });
        pageSlider.setEnabled(true);
    }

    public static class MyPagerProvider extends PageSliderProvider {

        @Override
        public int getCount() {
            return 2;
        }

        @Override
        public Object createPageInContainer(ComponentContainer componentContainer, int pos) {
            if (pos == 0) {
                componentContainer.addComponent(demoFragment);
                return demoFragment;
            }
            if (pos == 1) {
                componentContainer.addComponent(listFragment);
                return listFragment;
            }
            return null;
        }

        @Override
        public void destroyPageFromContainer(ComponentContainer componentContainer, int i, Object o) {
            componentContainer.removeComponent((Component) o);
        }

        @Override
        public boolean isPageMatchToObject(Component component, Object o) {
            return true;
        }
    }

    @Override
    public void onActive() {
        super.onActive();
    }

    @Override
    public void onForeground(Intent intent) {
        super.onForeground(intent);
    }
}