Package.describe({
  summary: "miscellaneous UI helpers"
});

Package.on_use(function (api) {
  api.use(
    [
      'coffeescript',
      'handlebars',
      'templating'
    ],
    'client'
  );
  api.export(
    [
      'obj',
      'elementChanged',
      'setupTabBar',
      'prefixUnchosen',
      'renderDatepicker',
      'addArrayItem',
      'deleteArrayItem',
      'updateArrayField'
    ]
  );
  api.add_files(
    [
      'misc-ui.coffee'
    ],
    'client'
  );
});
