React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'

require! {
    'lodash/trimStart'
    './balance.ls': {Total}
    './util.ls': {Pure}
    './tlist.css': style
}


export Transaction = $$$ (props) ->
    t = props.transaction
    tname = props.tstore.get-type(t.src, t.dest, t.amount)
    $table do
        key: t.id
        class-name: style.transaction
        on-click: props.on-click
        $tbody null,
            $tr null,
                $td class-name: style.dest, trim-start t.dest, ':'
                $td class-name: style.amount,
                    $span class-name: style.currency, t.currency
                    '\u00a0'
                    $span class-name: style[tname], t.amount / 100.0
            $tr null,
                $td class-name: style.date,
                    t.date.split(' ')[0]
                    '\u00a0'
                    t.description

                $td class-name: style.src, trim-start t.src, ':'


export TList = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        tstore = @props.tstore
        idx = tstore.transactions.length
        $div do
            style:
                padding: '0 1rem'
            while t = tstore.transactions[--idx]
                Transaction do
                    key: t.id
                    transaction: tstore.get(t.id)
                    tstore: tstore
                    on-click: (-> cash-router.open 'transaction-edit', id: it.id).bind null, t


export TSelectList = $$ React.create-class do
    get-initial-state: ->
        selected: {[r, true] for r in @props.group}

    select: (tid) !->
        if tid != @props.current
            @state.selected[tid] = !@state.selected[tid]
            @forceUpdate!

    on-save: !->
        group = [parseInt(k) for k, v of @state.selected when v]
        @props.on-save group

    render: ->
        tstore = @props.tstore
        selected = @state.selected
        idx = tstore.transactions.length
        $div do
            style:
                padding: '0 1rem'
            $button do
                class-name: 'mui-btn mui-btn--primary'
                on-click: @~on-save
                style:
                    position: \absolute
                    bottom: '10vw'
                    right: '10vw'
                'Save'
            $div class-name: 'scroll',
                while t = tstore.transactions[--idx]
                    Pure key: t.id, on: selected[t.id], ((t) ->
                        tc = Transaction do
                            transaction: tstore.get t.id
                            tstore: tstore
                            on-click: @select.bind @, t.id
                        if selected[t.id]
                            $div do
                                class-name: if t.id == @props.current
                                            then style.transaction-main
                                            else style.transaction-selected
                                tc
                        else
                            tc
                    ).bind @, t


export Main = $$ React.create-class do
    mixins: [PureRenderMixin]

    render: ->
        tstore = @props.tstore
        $div do
            class-name: 'full'
            $div do
                class-name: 'mui-panel'
                style: padding: '1rem', margin-bottom: 0
                on-click: -> cash-router.open 'account-list'
                Total {tstore}
            $div class-name: 'scroll', style: height: 'calc(100% - 2rem - 1.4rem)',
                TList tstore: tstore
            $button do
                class-name: 'mui-btn mui-btn--fab mui-btn--primary'
                on-click: !-> cash-router.open 'transaction-new'
                style:
                    position: \absolute
                    bottom: '10vw'
                    right: '10vw'
                '+'
