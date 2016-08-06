React = require 'react'
require! 'lodash/isEqual'


require! {
  './mutator.ls'
  './util.ls': {Pure, Field, TextField, date-format}
  './tlist.ls': {Transaction, TSelectList}
  './tedit.css': style
}


AmountField = Field do
    -> Math.round(eval(it) * 100)
    -> it / 100.0


export TransactionEdit = $$ React.create-class do
    get-initial-state: ->
        if @props.is-new
            t = {date: date-format(new Date), currency: 'RUB', amount: 0}
        else
            t = @props.tstore.get @props.id

        transaction: t
        tmut: mutator t, ~> @force-update!
        show-group-selector: false

    save: ->
        val = @state.tmut.val
        if @props.is-new
            @props.tstore.add val
        else
            if not isEqual val, @state.transaction
                @props.tstore.save val

        cash-router.back!
        return true

    render: ->
        tstore = @props.tstore
        tmut = @state.tmut
        t = tmut.val

        $div do
            class-name: 'scroll'
            style:
                padding: '1rem'
            $div null,
                $table style: width: '100%',
                    $tbody null,
                    $tr null,
                        Pure on: t.currency, ->
                            $td style: width: '30%',
                                $div class-name: 'mui-textfield mui-textfield--float-label',
                                    TextField mutator: tmut.to('currency'),
                                        $input type: 'text'
                                    $label null, 'Currency'
                        Pure on: t.amount, ->
                            $td style: padding-left: '1rem',
                                $div class-name: 'mui-textfield mui-textfield--float-label',
                                    AmountField mutator: tmut.to('amount'),
                                        $input type: 'text', auto-focus: true
                                    $label null, 'Amount'
                Pure on: t.src, ->
                    $div class-name: 'mui-textfield mui-textfield--float-label',
                        TextField mutator: tmut.to('src'), $input type: 'text'
                        $label null, 'From'
                Pure on: t.dest, ->
                    $div class-name: 'mui-textfield mui-textfield--float-label',
                        TextField mutator: tmut.to('dest'), $input type: 'text'
                        $label null, 'To'
                Pure on: t.description, ->
                    $div class-name: 'mui-textfield mui-textfield--float-label',
                        TextField mutator: tmut.to('description'), $textarea!
                        $label null, 'Note'
                Pure on: t.date, ->
                    $div class-name: 'mui-textfield mui-textfield--float-label',
                        TextField mutator: tmut.to('date'), $input type: 'text'
                        $label null, 'Date'

                $div class-name: 'mui--pull-right',
                    $button do
                        type: 'submit'
                        class-name: 'mui-btn mui-btn--raised mui-btn--danger'
                        on-click: @delete
                        'Delete'
                    $button do
                        type: 'submit'
                        class-name: 'mui-btn mui-btn--raised mui-btn--primary'
                        on-click: @save
                        'Save'

                $div class-name: 'mui--pull-left',
                    $button do
                        type: 'submit'
                        class-name: 'mui-btn mui-btn--raised mui-btn--accent'
                        on-click: ~> @set-state show-group-selector: true
                        'Group'

                Pure on: t.group, ->
                    $div class-name: style.group, for tid in t.group or []
                        if tid == t.id
                            continue
                        tt = tstore.get(tid)
                        Transaction key: tt.id, transaction: tstore.get(tt.id), tstore: tstore
            if @state.show-group-selector
                $div class-name: 'modal',
                    TSelectList do
                        current: t.id
                        tstore: tstore
                        group: t.group
                        on-save: ~>
                            tmut.to \group .set it
                            @set-state show-group-selector: false
