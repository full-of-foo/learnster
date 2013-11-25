##
# Standard student BB model specs
#


describe "new Student model", ->

    beforeEach ->
        @s = new Learnster.Entities.Student
                        first_name: "joe"
                        surname:     "blogs"
                        email:       "foo@bar.com"

    it "should be true", ->
        expect(@s).toBeTruthy()

    it "should expose an attribute", ->
        expect(@s.get('first_name')).toEqual("joe")

    url = Routes.api_student_index_path()

    it "url should be #{url}", ->
        expect(@s.url()).toEqual(url)


describe "Student collection", ->

    beforeEach ->
        @studs = new Learnster.Entities.StudentsCollection()
        @server = sinon.fakeServer.create()

    afterEach ->
        @server.restore()

    it "should be true", ->
        expect(@studs).toBeTruthy()

    it "should have the correct request size", ->
        @studs.fetch()
        expect(@server.requests.length).toEqual(1)

    url = Routes.api_student_index_path()

    it "should make the correct request url", ->
        @studs.fetch()
        expect(@server.requests[0].url).toEqual(url)
