React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'
ReactDOM = require 'react-dom'
is-array = require 'lodash/isArray'

window.$ = React.create-element
window.$$ = React.create-factory
for key, value of React.DOM
    window."$#key" = value

require! {
    './mutator.ls'
    './tstore.ls'
    './router.ls'
    './tlist.ls': {Main}
    './tedit.ls': {TransactionEdit}
    './app.css': styles
}

app-state = mutator do
    tstore: tstore.get!
    router: {}
    ->
        app?.set-state it


window.cash-router = router do
    open: (page, params=null) !->
        ui = app-state.mutator \router .detach!
        @set-hash(ui.mutator \pages .push [page, params])
    back: ->
        ui = app-state.mutator \router .detach!
        if ui.val.pages.length > 1
            @set-hash(ui.mutator \pages .pop!)
    default: ->
        pages: [[\main, null]]
    on-change: ->
        app-state.mutator \router .set it


App = $$ React.create-class do
    mixins: [PureRenderMixin]

    get-initial-state: ->
        app-state.val

    render: ->
        $div null,
            for [pname, params] in @state.router.pages
                if pname == 'main'
                    Main key: 'main', tstore: @state.tstore
                else if pname == 'transaction-edit'
                    TransactionEdit key: "main-#params.id", id: params.id, tstore: @state.tstore


app = ReactDOM.render do
    App!
    document.get-element-by-id \app
