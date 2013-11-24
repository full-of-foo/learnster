@Learnster.module "StudentsApp.Import", (Import, App, Backbone, Marionette, $, _, Routes) ->

  class Import.Dialog extends App.Views.ItemView
    template: 'students/import/templates/import_dialog'
    tagName: 'div'
    className: 'modal fade'

    onShow: ->
      @$el.modal()

      options =
        request:
          endpoint: Routes.api_organisation_import_users_path(@model.get('id'))
          customHeaders:
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr 'content'
          validation:
            allowedExtensions: ["csv", "xls", "xlsx"]
            sizeLimit: 5000000

      $('#student-upload-area').fineUploader(options).on 'submit', (id, name) ->
        $('#upload-results').html('');

      $('#student-upload-area').fineUploader(options).on 'error', (event, id, name, errorReason, xhrOrXdr) ->
        import_status_data = errorReason
        successfulRows = (row for row, val of import_status_data when val is true)
        errorRows = (row for row, val of import_status_data when val isnt true)

        if successfulRows.length > 0
          $('<div>')
            .attr('id', 'success-message')
            .attr('class', 'panel panel-success')
            .html('<div class="panel-heading">Successfully Imported</div><div class="panel-body">
              <ul id="success-row-list" class="fa-ul"></u></div>')
            .appendTo('#upload-results')
          successfulRows.forEach (r) ->
            $('#success-row-list')
              .append('<li><i class="fa-li fa fa-check-square"></i>' + r + '</li>')

        if errorRows.length > 0
          $('<div>')
            .attr('id', 'error-message')
            .attr('class', 'panel panel-danger')
            .html('<div class="panel-heading">Failed to Import</div><div class="panel-body">
              <ul id="error-row-list" class="fa-ul"></u></div>')
            .appendTo('#upload-results')
          errorRows.forEach (r) ->
            $('#error-row-list')
              .append('<li><i class="fa-li fa fa-thumbs-o-down"></i>' + r + '</li>')


, Routes