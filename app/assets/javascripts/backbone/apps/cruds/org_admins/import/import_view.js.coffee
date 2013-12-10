@Learnster.module "OrgAdminsApp.Import", (Import, App, Backbone, Marionette, $, _, Routes) ->

  class Import.Dialog extends App.Views.ItemView
    template: 'org_admins/import/templates/import_dialog'
    tagName: 'div'
    className: 'modal fade'

    onShow: ->
      @$el.modal()

      options =
        request:
          endpoint: Routes.api_organisation_import_admins_path(@model.get('id'))
          customHeaders:
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr 'content'
            'Authorization': $.cookie('auth_header') if $.cookie('auth_header')
          validation:
            allowedExtensions: ["csv", "xls", "xlsx"]
            sizeLimit: 5000000

      $('#admin-upload-area').fineUploader(options).on 'submit', (id, name) ->
        $('#upload-results').html('');

      $('#admin-upload-area').fineUploader(options).on 'error', (event, id, name, errorReason, xhrOrXdr) ->
        import_status_data = errorReason
        successfulRows = (row for row, val of import_status_data when val is true)
        errorRows = (row for row, val of import_status_data when val isnt true)
        errorData = {}
        errorRows.forEach (r) -> errorData[r] = import_status_data[r]

        if successfulRows.length > 0
          $('<div>')
            .attr('id', 'success-message')
            .attr('class', 'panel panel-success')
            .html('<div class="panel-heading">Successfully Imported</div><div class="panel-body">
              <ul id="success-row-list" class="fa-ul"></u></div>')
            .appendTo('#upload-results')
          $('#upload-results').hide()

          successfulRows.forEach (r) ->
            $('#success-row-list')
              .append('<li><i class="fa-li fa fa-check-square"></i>' + r + '</li>')
          App.vent.trigger 'admin:import:success', @

        if errorRows.length > 0
          $('<div>')
            .attr('id', 'error-message')
            .attr('class', 'panel panel-danger')
            .html('<div class="panel-heading">Failed to Import</div><div class="panel-body">
              <ul id="error-row-list" class="fa-ul"></ul></div>')
            .appendTo('#upload-results')
          $('#upload-results').hide()

          errorRows.forEach (row) ->
            row_id = row.replace(/\s+/g, '')
            $('#error-row-list')
              .append('<li id="' + row_id + '"><i class="fa-li fa fa-thumbs-o-down"></i>' + row + '</li></br>')
            if errorData[row] instanceof Object
              for own field, errors of errorData[row]
                fieldErrorListId = row_id + field
                $('li#' + row_id)
                  .append('<p class="text-warning">' + field + '</p><ul id="' + fieldErrorListId + '"></ul>')
                errors.forEach (error) ->
                  $('ul#' + fieldErrorListId)
                    .append('<li>' + error + '</li>')


        if _.isEmpty(import_status_data)
          $('<div>')
            .attr('id', 'error-message')
            .attr('class', 'panel panel-danger')
            .html('<div class="panel-heading">Failed to Import</div><div class="panel-body">
              <ul id="error-row-list" class="fa-ul"></u></div>')
            .appendTo('#upload-results')
          $('#upload-results').hide()

          $('#error-row-list')
            .append('<li><i class="fa-li fa fa-thumbs-o-down"></i>Empty template uploaded!</li>')

        $('#upload-results').slideDown 'slow'




, Routes