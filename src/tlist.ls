React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'

require! {
    'lodash/trimStart'
    './balance.ls': {Balance}
    './util.ls': {Pure}
    './tlist.css': styles
}


export Transaction = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        t = @props.transaction
        tname = @props.tstore.get-type(t.src, t.dest, t.amount)
        $table do
            key: t.id
            class-name: styles.transaction
            on-click: -> cash-router.open 'transaction-edit', id: t.id
            $tbody null,
                $tr null,
                    $td class-name: styles.dest, trim-start t.dest, ':'
                    $td class-name: styles.amount,
                        $span class-name: styles.currency, t.currency
                        '\u00a0'
                        $span class-name: styles[tname], t.amount / 100
                $tr null,
                    $td class-name: styles.date,
                        t.date.split(' ')[0]
                        '\u00a0'
                        t.description

                    $td class-name: styles.src, trim-start t.src, ':'


export TList = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        tstore = @props.tstore
        idx = tstore.transactions.length
        $div do
            style:
                padding: '0 3vw'
            while t = tstore.transactions[--idx]
                Transaction key: t.id, transaction: tstore.get(t.id), tstore: tstore


export Main = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        tstore = @props.tstore
        $div do
            class-name: 'full'
            Pure by: tstore, ->
                Balance tstore: tstore
            $div class-name: 'scroll',
                TList tstore: tstore
            $button do
                class-name: 'mui-btn mui-btn--fab mui-btn--primary'
                on-click: !-> cash-router.open 'transaction-new'
                style:
                    position: \absolute
                    bottom: '10vw'
                    right: '10vw'
                '+'
