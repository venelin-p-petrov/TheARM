package com.accedia.thearm;

import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;

import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Resource;

import java.util.ArrayList;

/**
 * Created by mihailkarev on 9/2/16.
 */
public class ResourceDialog extends DialogFragment {

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the Builder class for convenient dialog construction
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        final ArrayList<Resource> resources = ObjectsHelper.getInstance().getResources();
        ArrayList<String> resourceTitles = new ArrayList<String>();
        for (Resource resource: resources){
            resourceTitles.add(resource.getName());
        }

        builder.setTitle(R.string.pick_resource)
                .setItems(resourceTitles.toArray(new CharSequence[resourceTitles.size()]), new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        Resource resource = resources.get(which);
                        Intent intent = new Intent(getActivity(), CreateEventActivity.class);
                        intent.putExtra(CreateEventActivity.EXTRA_RESOURCE_ID, resource.getResourceId());
                        startActivity(intent);
                    }
                });

        // Create the AlertDialog object and return it
        return builder.create();
    }
}
