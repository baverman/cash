React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'
ReactDOM = require 'react-dom'
is-array = require 'lodash/isArray'
cn = require 'classnames'

window.$ = React.create-element
window.$$ = React.create-factory
for key, value of React.DOM
    window."$#key" = value

require! {
    './tlist.ls': {TList}
}

tstore = require './tstore.ls'
styles = require './app.css'


App = $$ React.create-class do
    mixins: [PureRenderMixin]

    get-initial-state: ->
        balance: false

    balance-clicked: ->
        @set-state balance: not @state.balance

    render: ->
        $div null,
            $div do
                key: \balance
                class-name: styles.page
                on-click: @balance-clicked
                style:
                    z-index: 10
                    top: if @state.balance then 0 else '-90%'
                'Balance'
            $div do
                key: \transactions
                class-name: styles.page
                style:
                    height: '90%'
                    top: '10%'
                TList tstore: tstore.get!


app = ReactDOM.render do
    App!
    document.get-element-by-id \app
