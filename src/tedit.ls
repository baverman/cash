React = require 'react'

require! {
  './mutator.ls'
  './util.ls': {Pure, Field}
  './app.css': appstyles
}


export TransactionEdit = $$ React.create-class do
    get-initial-state: ->
        t = @props.tstore.get @props.id
        tmut: mutator t, ~> @force-update!

    save: ->
        cash-router.back!

    render: ->
        tmut = @state.tmut
        t = tmut.val
        $div do
            class-name: appstyles.page
            $div do
                style:
                    padding: '1rem'
                $form null,
                    $table style: width: '100%',
                        $tbody null,
                        $tr null,
                            Pure by: t.currency, ->
                                $td style: width: '30%',
                                    $div class-name: 'mui-textfield mui-textfield--float-label',
                                        Field mutator: tmut.to('currency'),
                                            $input type: 'text'
                                        $label null, 'Currency'
                            Pure by: t.amount, ->
                                $td style: padding-left: '1rem',
                                    $div class-name: 'mui-textfield mui-textfield--float-label',
                                        Field mutator: tmut.to('amount'),
                                            $input type: 'text', ref: -> it?.focus!
                                        $label null, 'Amount'
                    Pure by: t.src, ->
                        $div class-name: 'mui-textfield mui-textfield--float-label',
                            Field mutator: tmut.to('src'), $input type: 'text'
                            $label null, 'From'
                    Pure by: t.dest, ->
                        $div class-name: 'mui-textfield mui-textfield--float-label',
                            Field mutator: tmut.to('dest'), $input type: 'text'
                            $label null, 'To'
                    Pure by: t.description, ->
                        $div class-name: 'mui-textfield mui-textfield--float-label',
                            Field mutator: tmut.to('description'), $textarea!
                            $label null, 'Note'
                    Pure by: t.date, ->
                        $div class-name: 'mui-textfield mui-textfield--float-label',
                            Field mutator: tmut.to('date'), $input type: 'text'
                            $label null, 'Date'

                    $div class-name: 'mui--text-right',
                        $button do
                            type: 'submit'
                            class-name: 'mui-btn mui-btn--raised mui-btn--primary'
                            on-click: @save
                            'Save'
