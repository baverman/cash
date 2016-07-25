React    = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin';

operations =
    * description: 'Пицца'
      trans:
          * src:  'cash'
            dest: 'food:shop'
            amount: 50000
            currency: 'RUB'
            date: '2016-06-24 23:06:01'
          * src:  'debt:tolya'
            dest: 'food:shop'
            amount: 15000
            currency: 'RUB'
            date: '2016-06-24 23:06:01'
          * src:  'cash'
            dest: 'dept:tolya'
            amount: 15000
            currency: 'RUB'
            date: '2016-06-28 24:05:01'
    * trans:
          * src:  'cards:alfa:main'
            dest: 'cash'
            amount: 490000
            currency: 'RUB'
            date: '2016-06-25 23:06:01'
    * trans:
          * src:  'cards:alfa:credit'
            dest: 'food:restaurant'
            amount: 98000
            currency: 'RUB'
            date: '2016-06-26 23:06:01'


window.$ = React.create-element
window.$$ = React.create-factory
for key, value of React.DOM
    window."$#key" = value


App = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        console.log operations
        $div null 'Hoo'


app = ReactDOM.render do
    App!
    document.get-element-by-id \app
