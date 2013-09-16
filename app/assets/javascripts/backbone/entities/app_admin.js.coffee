@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.AppAdmin extends Entities.Models
        urlRoot: Routes.app_admin_index_path()
