package com.accedia.thearm.adapters;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.Image;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.TextView;

import com.accedia.thearm.R;
import com.accedia.thearm.models.Resource;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class ResourceListAdapter extends BaseAdapter implements ListAdapter {

    private Context context;
    private List<Resource> items = new ArrayList<Resource>();

    public ResourceListAdapter(Context context, List<Resource> items) {
        this.context = context;
        this.items = items;
    }

    @Override
    public int getCount() {
        return items.size();
    }

    @Override
    public Object getItem(int position) {
        return items.get(position);
    }

    @Override
    public long getItemId(int position) {
        return items.get(position).hashCode();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        if (convertView == null){
            convertView = inflater.inflate(R.layout.list_item_resource, parent, false);
        }

        Resource resourceItem = (Resource)getItem(position);

        TextView textResourceName = (TextView) convertView.findViewById(R.id.list_item_resource_name);
        ImageView imageResourceImage = (ImageView) convertView.findViewById(R.id.list_item_resource_image);

        if (textResourceName != null){
            textResourceName.setText(resourceItem.getName());
        }

        // TODO set image
//        if (imageResourceImage != null){
//            imageResourceImage.setImageBitmap(resourceItem.getImage());
//        }

        return convertView;
    }

}
