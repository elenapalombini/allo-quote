-- a Client is used to connect this app to a Place. arg[2] is the URL of the place to
-- connect to, which Assist sets up for you.
local client = Client(
    arg[2], 
    "allo-todo"
)

-- App manages the Client connection for you, and manages the lifetime of the
-- your app.
local app = App(client)

assets = {
    quit = ui.Asset.File("images/quit.png"),
}
app.assetManager:add(assets)


class.TodosView(ui.Surface)
function TodosView:_init(bounds)
    self:super(bounds)
    self.grabbable = true

    self.quitButton = self:addSubview(ui.Button(ui.Bounds{size=ui.Size(0.12,0.12,0.05)}))
    self.quitButton:setDefaultTexture(assets.quit)
    self.quitButton.onActivated = function()
        app:quit()
    end

    self.addButton = self:addSubview(ui.Button(ui.Bounds{size=ui.Size(bounds.size.width*0.8,0.1,0.05)}))
    self.addButton.label:setText("Add todo")
    self.addButton.onActivated = function(hand)
        self:showNewTodoPopup(hand)
    end
    
    self.tasks = {}

    self:layout()
end

function TodosView:showNewTodoPopup(hand)
    local popup = ui.Surface(ui.Bounds{size=ui.Size(1,0.5,0.05)})

    local input = popup:addSubview(ui.TextField{
        bounds= ui.Bounds{size=ui.Size(0.8,0.1,0.05)}:move(0, 0.15, 0.025)
    })
    local done = function()
        self:addTodo(input.label.text)
        popup:removeFromSuperview()
    end
    input.onReturn = function()
        done()
        return false
    end
    input:askToFocus(hand)

    local addButton = popup:addSubview(ui.Button(ui.Bounds{size=ui.Size(popup.bounds.size.width*0.8,0.1,0.05)}))
    addButton.bounds:move(0, 0, 0.025)
    addButton.label:setText("Add")
    addButton.onActivated = done

    local cancelButton = popup:addSubview(ui.Button(ui.Bounds{size=ui.Size(popup.bounds.size.width*0.8,0.1,0.05)}))
    cancelButton:setColor({0.4, 0.4, 0.3, 1.0})
    cancelButton.bounds:move(0, -0.15, 0.025)
    cancelButton.label:setText("Cancel")
    cancelButton.onActivated = function()
        popup:removeFromSuperview()
    end

    app:openPopupNearHand(popup, hand)
end

function TodosView:addTodo(text)

end

function TodosView:layout()
    self.quitButton.bounds:moveToOrigin():move( 0.52,0.25,0.025)
    self.addButton.bounds:moveToOrigin():move( 0, -0.15,0.025)
end

app.mainView = TodosView(ui.Bounds(0, 1.2, -2,   1, 0.5, 0.01))
app:connect()
app:run()
