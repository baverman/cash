React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'
styles = require './tlist.css'


export Transaction = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        t = @props.transaction
        tname = @props.tstore.get-type(t.src, t.dest, t.amount)
        $table key: t.id, class-name: styles.transaction,
            $tbody null,
                $tr null,
                    $td class-name: styles.dest, t.dest
                    $td class-name: styles.amount,
                        $span class-name: styles.currency, t.currency
                        '\u00a0'
                        $span class-name: styles[tname], t.amount / 100
                $tr null,
                    $td class-name: styles.date, t.date
                    $td class-name: styles.src, t.src


export TList = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        $div null,
            for t in @props.tstore.transactions
                Transaction key: t.id, transaction: t, tstore: @props.tstore