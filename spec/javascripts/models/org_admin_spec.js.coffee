##
# Standard org admin BB model specs
#


describe "new Org Admin model", ->

    beforeEach ->
        @oa = new Learnster.Entities.OrgAdmin
                        first_name: "joe"
                        surname:     "blogs"
                        email:       "foo@bar.com" 

    it "should be true", ->
        expect(@oa).toBeTruthy()

    it "should expose an attribute", ->
        expect(@oa.get('first_name')).toEqual("joe")

    url = Routes.org_admin_index_path()

    it "url should be #{url}", ->
        expect(@oa.url()).toEqual(url)


describe "Student collection", ->

    beforeEach ->
        @studs = new Learnster.Entities.OrgAdminCollection()
        @server = sinon.fakeServer.create()

    afterEach ->
        @server.restore()

    it "should be true", ->
        expect(@studs).toBeTruthy()

    it "should have the correct request size", ->
        @studs.fetch()
        expect(@server.requests.length).toEqual(1)
       
    url = Routes.org_admin_index_path()

    it "should make the correct request url", ->
        @studs.fetch()
        expect(@server.requests[0].url).toEqual(url)
