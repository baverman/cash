React    = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'
Button = require 'muicss/lib/react/button'
Form = require 'muicss/lib/react/form'
Input = require 'muicss/lib/react/input'
Textarea = require 'muicss/lib/react/textarea'

require! {
  './app.css': appstyles
}


export TransactionEdit = $$ React.create-class do
    mixins: [PureRenderMixin]

    save: ->
        cash-router.back!

    render: ->
        t = @props.tstore.get @props.id
        $div do
            class-name: appstyles.page
            $div do
                style:
                    padding: '1rem'
                $ Form, null,
                    $table style: width: '100%',
                        $tbody null,
                        $tr null,
                            $td style: width: '30%',
                                $ Input, label: 'Currency', value: t.currency, floating-label: true
                            $td style: padding-left: '1rem',
                                $ Input, label: 'Amount', value: t.amount / 100, floating-label: true, auto-focus: true
                    $ Input, label: 'From', value: t.src, floating-label: true
                    $ Input, label: 'To', value: t.dest, floating-label: true
                    $ Textarea, label: 'Note', value: t.description, floating-label: true
                    $ Input, label: 'Date', value: t.date, floating-label: true
                    $div class-name: 'mui--text-right',
                        $ Button,
                            variant: 'raised'
                            color: 'primary'
                            on-click: @save
                            'Save'
