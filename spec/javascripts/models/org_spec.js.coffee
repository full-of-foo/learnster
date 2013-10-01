##
# Standard org BB model specs
#

describe "new Org model", ->

    beforeEach ->
        @o = new Learnster.Entities.Org
                        title:       "foo"
                        description: "place of foos and bars" 

    it "should be true", ->
        expect(@o).toBeTruthy()

    it "should expose an attribute", ->
        expect(@o.get('title')).toEqual("foo")

    url = Routes.organisation_index_path()

    it "url should be #{url}", ->
        expect(@o.url()).toEqual(url)


describe "Org collection", ->

    beforeEach ->
        @orgs = new Learnster.Entities.OrgsCollection()
        @server = sinon.fakeServer.create()

    afterEach ->
        @server.restore()

    it "should be true", ->
        expect(@orgs).toBeTruthy()

    it "should have the correct request size", ->
        @orgs.fetch()
        expect(@server.requests.length).toEqual(1)
       
    url = Routes.organisation_index_path()

    it "should make the correct request url", ->
        @orgs.fetch()
        expect(@server.requests[0].url).toEqual(url)
