@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.TableConfig extends Entities.Models
        defaults:
            spanClass: "span10"
