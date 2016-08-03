React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'
ReactDOM = require 'react-dom'
cn = require 'classnames'
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
    './app.css': style
}

tstore = tstore.get!

app-state = mutator do
    tstore: tstore
    router: {}
    ->
        app?.set-state it

tstore.on-change = -> app-state.to \tstore .set it


router-mutator = app-state.to \router .detach!
window.cash-router = router do
    open: (page, params=null) !->
        @set-state(router-mutator.to \pages .push [page, params])
    back: ->
        if router-mutator.val.pages.length > 1
            @set-state(router-mutator.to \pages .pop!)
    default: ->
        pages: [[\main, null]]
    on-change: ->
        app-state.to \router .set it


Page = $$ React.create-class do
    render: ->
        $div do
            class-name: cn style.page, (style.page-active): @props.active
            @props.children


App = $$ React.create-class do
    mixins: [PureRenderMixin]

    get-initial-state: ->
        app-state.val

    render: ->
        pages = @state.router.pages
        $div null,
            for [pname, params], idx in pages
                active = idx == pages.length - 1
                if pname == 'main'
                    Page key: 'main', active: active,
                        Main tstore: @state.tstore
                else if pname == 'transaction-edit'
                    Page key: "main-#params.id", active: active,
                        TransactionEdit id: params.id, tstore: @state.tstore


app = ReactDOM.render do
    App!
    document.get-element-by-id \app
