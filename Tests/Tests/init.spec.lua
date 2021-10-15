local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
return function()
    describe("Api structure", function()
        local apiDocs = {
            GetCamsById = "function",
            GetCamById = "function",
            GetDefaultCamPosition = "function",
            ChangeCam = "function"
        }
    
        for apiName, apiType in pairs(apiDocs) do
            local realValue = rawget(api, apiName)
            local realType = typeof(realValue)
    
            it(apiName .. " should be the correct type", function()
                expect(realType).to.be.equal(apiType)
            end)
        end
    
        for realName, realValue in pairs(api) do
            local realType = typeof(realValue)
            local apiType = apiDocs[realName] or "nil"
    
            it(realName .. " should be the correct type in reverse", function()
                expect(realType).to.be.equal(apiType)
            end)
        end
    end)
    it("Should be a table", function()
        expect(api).to.be.a("table")
    end)

    describe("GetCamsById", function()
        local returned = api:GetCamsById()
        it("Should return a table", function()
            expect(returned).to.be.a("table")
        end)
        it ("Should contain a Static table", function()
            expect(returned.Static).to.be.a("table")
        end)
        it ("Should contain a Moving table", function()
            expect(returned.Moving).to.be.a("table")
        end)
        it ("Should contain a Default Vector3", function()
            expect(typeof(returned.Default)).to.equal("CFrame")
        end)
    end)

    describe("GetDefaultCamPosition", function()
        local returned = api:GetDefaultCamPosition()
        it("Should return a CFrame", function()
            expect(typeof(returned)).to.equal("CFrame")
        end)
    end)

    describe("ChangeCam", function()
        it("Should not throw under normal use", function()
            expect(function()
                api:ChangeCam("Static",1)
            end).to.never.throw()
        end)
        it("Should throw under incorrect use", function()
            expect(function()
                api:ChangeCam("Static",math.huge)
            end).to.throw()
        end)
    end)
end