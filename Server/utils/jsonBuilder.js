module.exports = 
{
    buildJsonObject : function (key, value)
    {
        var objectToReturn = {};
        objectToReturn[key] = value;
        return objectToReturn;
    },
    buildStringJsonObject: function (key, value)
    {
        var objectToReturn = {};
        objectToReturn[key] = value;
        return JSON.stringify(objectToReturn);
    },
    addJsonValue: function (jsonObject, key, value)
    {
        jsonObject[key] = value;
    }
}