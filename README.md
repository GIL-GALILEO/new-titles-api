# GIL New Titles API

## Use

USG Member Institutions can request an API key from [me](mailto:mak@uga.edu).

A basic front-end powered by jQuery Datatables can be found at <https://newtitles.gil.usg.edu>

### Sending Requests

_See the [titles spec file](https://github.com/GIL-GALILEO/new-titles-api/blob/master/spec/request/titles_spec.rb) for more guidance_

Requests are sent to `https://newtitles.gil.usg.edu/api/v1/list`

Your API Key should be sent in the HTTP Headers as:

```'X-User-Token': YOUR_API_KEY```

The API Key will limit the returned records to only those from your institution.

Optionally, you cna send a parameter to specify a media_type:

`https://newtitles.gil.usg.edu/api/v1/list?media_type=DVD`

Or, you can limit by location value (be sure to URL encode values):

`https://newtitles.gil.usg.edu/api/v1/list?location=Main+Library+-+Second+Floor+%28Rotunda%29`

#### Media Types

See the [media type translation hash](https://github.com/GIL-GALILEO/new-titles-api/blob/f97b4c2823d754a428c549b08f4e88552ca50c19/app/controllers/titles_controller.rb#L36)
for all available parameter values and the corresponding Alma values.

### Response Object

The response will be a JSON array of title objects, e.g.:

```
[
    {
        "title":"Title of New Title", 
        "author":"Author", 
        "publisher":"Publisher", 
        "call_number":"LC Call number", 
        "library":"Library at your Institutions", 
        "location":"Location at your Institution, 
        "material_type":"Alma media type", 
        "receiving_date":"2018-09-05", 
        "mms_id":"5096308454493377", 
        "subjects":"Comma, separated, subjects", 
        "isbn":"ISBN, if present", 
        "publication_date":"Publication Date, if provided", 
        "portfolio_name":"For elecronic records", 
        "portfolio_activation_date":"For electronic records", 
        "portfolio_creation_date":"For electronic records", 
        "classification_code":"LC Classification code, if available, 
        "availability":"Alma title availability", 
        "call_number_sort":"Sortable version of call number", 
        "inst_name":"Your Institution"
    }
]
```