# misc-ui

Miscellaneous UI helpers.


## obj

`obj(key, value [, key, value]...)`

Easily construct object values when the keys are computed instead of constant.

That is, instead of having to say

```
o = {}
o["a" + 5] = "five"
o[fieldName] = "this"
o["array." + n + ".foo"] = "that"
```

you can say

`obj("a" + 5, "five", fieldName, "this", "array." + n ".foo", "that")`


## elementChanged

`elementChanged(template, callback)`

Retrieves the new value of some common form elements when changed by
the user: text inputs, checkboxes, textareas, and select dropdowns.
The elements should have a name attribute.

Call it with a template and it adds a "change" event handler to the
template.

When the user changes an element, the callback is called with three
arguments: the template instance (as passed to the event handler by
Meteor), the name of the element (as found in the name attribute of
the element), and the new value.

For text inputs and textareas, the new value will be the text in the element.

For select elements, the new value is the option value attribute of
the selected option.

For checkboxes, the new value is true or false.


## setTabBar

```
setupTabBar(
  sessionVariableName,
  defaultTab,
  tabBarTemplate,
  tabPaneTemplate
)
```

For Bootstrap
[nav bars](http://getbootstrap.com/2.3.2/components.html#navbar),
an alternative to using the Bootstrap JavaScript
[`$().tab`](http://getbootstrap.com/2.3.2/javascript.html#tabs)
component code.

This version updates the active tab based on a Meteor Session variable.

In the template markup, use the `active` template helper to select the
active tab and use the `data-name` attribute for the name of the tab.

For example,

```
<ul class="nav">
  <li class="{{active "home"}}"><a href="" data-name="home">Home</a></li>
  <li class="{{active "two"}}"><a href="" data-name="two">Two</a></li>
  <li class="{{active "three"}}><a href="" data-name="three">Link</a></li>
</ul>
```

And then for the panes:

```
<div class="tab-content">
  <div class="tab-pane {{active "home"}}" id="home">...</div>
  <div class="tab-pane {{active "two"}}" id="two">...</div>
  <div class="tab-pane {{active "three"}}" id="three">...</div>
</div>

The arguments to `setupTabBar` are:

* sessionVariableName: the name of the Session variable uses to
  contain the name of the active tab (in the above example, "home",
  "two", etc.)

* defaultTab: the name of the default tab to show (e.g. "show")

* tabBarTemplate: the template containing the tab bar
  (e.g. Template.tabBar)

* tabPaneTemplate: the templates containing the tab panes
  (e.g. Template.tabPanes)


## prefixUnchosen

`prefixUnchosen(list)`

For a select element dropdown, it can be important to provide an
"unselected" or "unknown" option.  This function prepends an option
titled "--" with a blank id, to indicate the unselected option.

The `list` argument can be an array or a
[cursor](http://docs.meteor.com/#meteor_collection_cursor).  It should
contain documents or objects that have `_id` and `title` fields.


## selected

`{{selected a b}}`

A Handlebars helper that returns "selected" if `a` equals `b` and the
empty string otherwise.


## checked

`{{checked bool}}`

A Handlebars helper that returns "checked" if bool is true and the
empty string otherwise.


## renderDatepicker

`renderDatepicker(template, inputName, buttonName, updateValue)`

For use with
[bootstrap-datepicker2](https://atmosphere.meteor.com/package/bootstrap-datepicker2),
attaches the datepicker to a template.  `updateValue` is a callback
called when the user selects a date in the datepicker calendar.

Use with markup like this:

```
<div class="input-append">
  <input name="date" type="text" value="{{date}}">
  <button name="date-button" class="btn">
    <i class="icon-calendar"></i>
  </button>
</div>
```

which can be wired up with:

```
renderDatepicker(Template.myTemplate, "date", "date-button", callback)
```


## embedded Mongo arrays

MongoDB suggests denormalizing data relationships.  For example,
[Model Embedded One-to-Many Relationships Between
Documents](http://docs.mongodb.org/manual/tutorial/model-embedded-one-to-many-relationships-between-documents/)
considers a person who has multiple addresses.  Unless the addresses
need to be referenced independently for some reason, the usual
practice in MongoDB is to include the addresses as an array inside of
the person document.

However using document arrays in templates with `{{#each}}` is
somewhat awkward at the moment since Meteor doesn't yet provide a way
to get the index of an array element. (See
[#912](https://github.com/meteor/meteor/pull/912) for discussion).

As a temporary workaround, this code adds the index of the array
element as a field `n` in the array element.  (This isn't a good idea
if multiple people are editing different array elements at the same
time, but is OK if there's just one person making changes).


### addArrayItem

`addArrayItem(collection, id, arrayFieldName [, doc])`

In the collection document with the specified id, appends to the array
named `arrayFieldName adding a new sub-document.  The added object is
extended with a field `n` which contains the index of the object in
the array.

For example,

`addArrayItem(People, personId, 'addresses', {street: "123 Elm", ...})`


### deleteArrayItem

`deleteArrayItem(collection, id, arrayFieldName, n)`

Removes the array item indexed by `n` from the passed collection, in
the document with the specified `id`.

The other items in the array have their `n` field modified so that the
index remains consecutive.


### updateArrayField

`updateArrayField(collection, id, arrayFieldName, n, fieldName, value)`

A convenience function for updating one field in an array item.  For
example,

`updateArrayField(People, personId, 'addresses', 3, 'street', '123 Elm')`


## userName

`{{userName userId}}`

A handlebars helper which returns the user's profile name, or a blank
string if the name isn't available.
