@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


	class Entities.Activity extends Entities.Models
		urlRoot: Routes.api_activities_path()

	class Entities.ActivitiesCollection extends Entities.Collections
        url: Routes.api_activities_path()
		model: Entities.Activity