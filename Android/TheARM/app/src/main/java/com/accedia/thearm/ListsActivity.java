package com.accedia.thearm;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.accedia.thearm.adapters.EventListAdapter;
import com.accedia.thearm.adapters.ResourceListAdapter;
import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

import org.json.JSONException;

import java.text.ParseException;
import java.util.concurrent.ExecutionException;

public class ListsActivity extends AppCompatActivity {

    /**
     * The {@link android.support.v4.view.PagerAdapter} that will provide
     * fragments for each of the sections. We use a
     * {@link FragmentPagerAdapter} derivative, which will keep every
     * loaded fragment in memory. If this becomes too memory intensive, it
     * may be best to switch to a
     * {@link android.support.v4.app.FragmentStatePagerAdapter}.
     */
    private SectionsPagerAdapter mSectionsPagerAdapter;

    /**
     * The {@link ViewPager} that will host the section contents.
     */
    private ViewPager mViewPager;
    private SlidingMenu menu;
    public static EventListAdapter eventListAdapter;

    private static FloatingActionButton fabNewEvent;

    private int[] tabIcons = {R.drawable.eventsnotactive,R.drawable.resourcesnotactive};
    private int[] selectedTabIcons = {R.drawable.eventsactive,R.drawable.resourcesactive};

    //private static List<Resource> resources = new ArrayList<Resource>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lists);

        setupSlidingMenu();

        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(this)
                .diskCacheSize(50 * 1024 * 1024)
                .diskCacheFileCount(100)
                .build();

        ImageLoader.getInstance().init(config);


        // Create the adapter that will return a fragment for each of the three
        // primary sections of the activity.
        mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

        // Set up the ViewPager with the sections adapter.
        mViewPager = (ViewPager) findViewById(R.id.container);
        mViewPager.setAdapter(mSectionsPagerAdapter);
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (position == 0) {
                    fabNewEvent.setVisibility(View.VISIBLE);
                } else if (position == 1) {
                    fabNewEvent.setVisibility(View.GONE);
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tabs);
        tabLayout.setupWithViewPager(mViewPager);


        tabLayout.getTabAt(0).setIcon(selectedTabIcons[0]);
        tabLayout.getTabAt(1).setIcon(tabIcons[1]);
        tabLayout.setTabTextColors(R.color.grayTextColor, R.color.grayTextColor);

        tabLayout.setOnTabSelectedListener(
                new TabLayout.ViewPagerOnTabSelectedListener(mViewPager) {

                    @Override
                    public void onTabSelected(TabLayout.Tab tab) {
                        super.onTabSelected(tab);
                        int position  = tab.getPosition();
                        tab.setIcon(selectedTabIcons[position]);
                    }

                    @Override
                    public void onTabUnselected(TabLayout.Tab tab) {
                        super.onTabUnselected(tab);
                        int position  = tab.getPosition();
                        tab.setIcon(tabIcons[position]);
                    }

                    @Override
                    public void onTabReselected(TabLayout.Tab tab) {
                        super.onTabReselected(tab);
                    }
                }
        );


        fabNewEvent = (FloatingActionButton) findViewById(R.id.fab_new_event);
        fabNewEvent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ResourceDialog dialog = new ResourceDialog();
                dialog.show(getFragmentManager(), "dialog");
            }
        });

        fabNewEvent.setVisibility(View.VISIBLE);

    }

    private void setupSlidingMenu() {
        menu = new SlidingMenu(this);
        menu.setMode(SlidingMenu.LEFT);
        menu.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);
//        activity_menu.setShadowWidthRes(R.dimen.shadow_width);
//        activity_menu.setShadowDrawable(R.drawable.shadow);
        menu.setBehindOffset(100);
        menu.setFadeDegree(0.35f);
        menu.attachToActivity(this, SlidingMenu.SLIDING_CONTENT);
        menu.setMenu(R.layout.activity_menu);


        TextView textUserId = (TextView) findViewById(R.id.user_id);
        TextView textDisplayName= (TextView) findViewById(R.id.display_name);
        textUserId.setText(ObjectsHelper.getInstance().getCurrentUser().getUsername());
        textDisplayName.setText(ObjectsHelper.getInstance().getCurrentUser().getDisplayName());
        Button logoutButton = (Button)findViewById(R.id.logout_button);
        logoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ObjectsHelper.getInstance().logoutCurrentUser(ListsActivity.this);
                Intent intent = new Intent(ListsActivity.this, MainActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
            }
        });
        menu.showMenu();
    }

    @Override
    protected void onResume() {
        super.onResume();

        try {
            Log.w("DEBUG", "activity resume");
            ApiHelper.getEvents(1/*ObjectsHelper.getInstance().getCurrentUser().getCompanyId()*/);
            ApiHelper.getResources(1/*ObjectsHelper.getInstance().getCurrentUser().getCompanyId()*/);
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    /**
     * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
     * one of the sections/tabs/pages.
     */
    public class SectionsPagerAdapter extends FragmentPagerAdapter {

        public SectionsPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            // getItem is called to instantiate the fragment for the given page.
            // Return a PlaceholderFragment (defined as a static inner class below).
            return PlaceholderFragment.newInstance(position + 1);
        }

        @Override
        public int getCount() {
            // Show 2 total pages.
            return 2;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            switch (position) {
                case 0:
                    return "Events";
                case 1:
                    return "Resources";
            }
            return null;
        }
    }

    /**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {
        /**
         * The fragment argument representing the section number for this
         * fragment.
         */
        private static final String ARG_SECTION_NUMBER = "section_number";

        /**
         * Returns a new instance of this fragment for the given section
         * number.
         */
        public static PlaceholderFragment newInstance(int sectionNumber) {
            PlaceholderFragment fragment = new PlaceholderFragment();
            Bundle args = new Bundle();
            args.putInt(ARG_SECTION_NUMBER, sectionNumber);
            fragment.setArguments(args);
            return fragment;
        }

        public PlaceholderFragment() {
        }
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            int sectionNumber = getArguments().getInt(ARG_SECTION_NUMBER);

            View rootView = null;
            if (sectionNumber == 1) {
                rootView = inflater.inflate(R.layout.fragment_events, container, false);

                ListView listEvents = (ListView) rootView.findViewById(R.id.list_events);
                eventListAdapter = new EventListAdapter(getContext(), ObjectsHelper.getInstance().getEvents());
                eventListAdapter.updateEvents(listEvents);
                listEvents.setAdapter(eventListAdapter);
                listEvents.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                        Intent intent = new Intent(getContext(), ViewEventActivity.class);
                        Event event = ObjectsHelper.getInstance().getEvents().get(position);
                        intent.putExtra(ViewEventActivity.EXTRA_EVENT_ID, event.getEventId());
                        startActivity(intent);
                    }
                });
            } else if (sectionNumber == 2) {
                rootView = inflater.inflate(R.layout.fragment_resources, container, false);
                ListView listResources = (ListView) rootView.findViewById(R.id.list_resources);
                BaseAdapter adapter = new ResourceListAdapter(getContext(), ObjectsHelper.getInstance().getResources());
                listResources.setAdapter(adapter);
                listResources.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                        Intent intent = new Intent(getContext(), CalendarActivity.class);
                        Resource resource = ObjectsHelper.getInstance().getResources().get(position);
                        intent.putExtra(CalendarActivity.EXTRA_RESOURCE_ID, resource.getResourceId());
                        startActivity(intent);
                    }
                });
            }
            return rootView;
        }



        @Override
        public void onResume() {
            super.onResume();
            eventListAdapter.notifyDataSetChanged();
        }
    }
}
