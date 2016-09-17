package com.accedia.thearm.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListAdapter;
import android.widget.TextView;

import com.accedia.thearm.R;
import com.accedia.thearm.models.User;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mihailkarev on 9/2/16.
 */
public class ParticipantsAdapter extends BaseAdapter implements ListAdapter {

    private Context context;
    private List<User> participients;

    public ParticipantsAdapter(Context context, List<User>  participients) {
        if(participients == null) {
            participients = new ArrayList<User>();
        }
        this.context = context;
        this.participients = participients;
    }

    @Override
    public int getCount() {
        return participients.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        if (convertView == null) {
            convertView = inflater.inflate(R.layout.list_item_participient, parent, false);
        }
        User user = participients.get(position);

        if (user != null) {
            TextView textPlayerNumber = (TextView) convertView.findViewById(R.id.player_number);
            TextView textPlayerName = (TextView) convertView.findViewById(R.id.player_name);

            textPlayerNumber.setText("Player " + (++position));
            textPlayerName.setText(user.getDisplayName());
        }

        return convertView;
    }
}
