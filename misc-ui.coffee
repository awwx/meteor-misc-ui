obj = (args...) ->
  o = {}
  for i in [0 ... args.length] by 2
    o[args[i]] = args[i + 1]
  return o


elementChanged = (template, callback) ->
  template.events
    'change': (event, templateInstance) ->
      $element = $(event.currentTarget)
      name = $element.attr('name')
      if $element.is('input:checkbox')
        callback(templateInstance, name, $element.prop('checked'))
      else if $element.is('input:text')
        callback(templateInstance, name, $element.val())
      else if $element.is('select')
        callback(templateInstance, name, $('option:selected', $element).val())
      else if $element.is('textarea')
        callback(templateInstance, name, $element.val())


setupTabBar = (sessionVar, defaultTab, tabBarTemplate, tabPaneTemplate) ->

  Session.setDefault(sessionVar, defaultTab)

  tabBarTemplate.events
    'click ul.nav>li>a': (event) ->
      event.preventDefault()
      Session.set(
        sessionVar,
        $(event.currentTarget).attr('data-name')
      )
      return


  active = (tabName) ->
    if Session.equals(sessionVar, tabName)
      'active'
    else
      ''

  tabBarTemplate.active = active

  tabPaneTemplate.active = active

  return


prefixUnchosen = (list) ->
  if list?.fetch? and _.isFunction(list.fetch)
    list = list.fetch()
  list = _.clone(list)
  list.unshift {_id: '', title: '--'}
  return list


Handlebars.registerHelper 'selected', (a, b) ->
  if a is b then 'selected' else ''


Handlebars.registerHelper 'checked', (value) ->
  if value then 'checked' else ''


renderDatepicker = (template, inputName, buttonName, updateValue) ->
  $input = $(template.find("""input[name="#{inputName}"]"""))
  $button = $(template.find("""button[name="#{buttonName}"]"""))

  unless $button.data('datepicker')
    datepicker = $button.datepicker()

    datepicker.on 'show', (event) =>
      v = $.trim($input.val())
      if v is ""
        v = moment.utc().format("YYYY-MM-DD")
      $button.datepicker('update', moment.utc(v, "YYYY-MM-DD").toDate())
      return

    datepicker.on 'changeDate', (event) =>
      v = moment.utc(event.date).format("YYYY-MM-DD")
      $input.val(v)
      $button.datepicker('hide')
      updateValue(v)
      return


addArrayItem = (collection, id, arrayFieldName, doc = {}) ->
  n = collection.findOne(id)[arrayFieldName]?.length ? 0
  doc = _.extend(doc, {n})
  collection.update(id, {$push: obj(arrayFieldName, doc)})
  return


deleteArrayItem = (collection, id, arrayFieldName, n) ->
  array = collection.findOne(id)[arrayFieldName]
  array.splice(n, 1)
  for i in [0 ... array.length]
    array[i].n = i
  collection.update(
    id,
    {$set: obj(arrayFieldName, array)}
  )
  return


updateArrayField = (collection, id, arrayFieldName, n, fieldName, value) ->
  collection.update(
    id,
    {$set: obj("#{arrayFieldName}.#{n}.#{fieldName}", value)}
  )
  return


Handlebars.registerHelper 'userName', (userId) ->
  Meteor.users.findOne(userId)?.profile?.name ? ''
