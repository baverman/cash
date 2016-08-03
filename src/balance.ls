React = require 'react'

require! {
    './balance.css': style
}


export Balance = $$ React.create-class do
    render: ->
        b = @props.tstore.balance.dr-cr!
        $div do
            class-name: style.balance
            $table null,
                $tbody null,
                    $tr null,
                        $td null,
                            $span class-name: style.debit, "#{b.debit / 100}"
                            '\u00a0\u2212\u00a0'
                            $span class-name: style.credit, "#{b.credit / 100}"
                        $td class-name: style.right,
                            '=\u00a0'
                            $span class-name: style.total, "#{(b.debit - b.credit) / 100}"
