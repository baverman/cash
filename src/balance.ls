React = require 'react'

require! {
    './util.ls': {Pure}
    './balance.css': style
}


export Total = $$$ (props) -> Pure on: props.tstore, ->
    b = props.tstore.balance.dr-cr!
    $table class-name: style.balance,
        $tbody null,
            $tr null,
                $td null,
                    $span class-name: style.debit, "#{b.debit / 100}"
                    '\u00a0\u2212\u00a0'
                    $span class-name: style.credit, "#{b.credit / 100}"
                $td class-name: style.right,
                    '=\u00a0'
                    $span class-name: style.total, "#{(b.debit - b.credit) / 100}"


export balance-tree = (root, level, result) ->
    for name, sub of root.sub
        result.push [name, sub, level]
        balance-tree sub, level + 1, result

    return result


export Accounts = $$$ (props) -> Pure on: props.tstore, ->
    $div class-name: 'full',
        $div do
            class-name: 'scroll'
            style:
                height: 'calc(100% - 6vw - 1.4rem)'
                padding: '3vw 3vw 0 3vw'
            $table class-name: style.account-list, $tbody null,
                for [name, b, level] in balance-tree props.tstore.balance, 0, []
                    amount = b.balance() / 100
                    $tr key: "#{level}-#{name}",
                        $td style: padding-left: "#{level * 1.5}rem", name
                        $td null,
                            $span do
                                class-name: if amount < 0 then style.credit else style.debit
                                amount
        $div class-name: 'mui-panel', style: padding: '3vw',
            Total tstore: props.tstore
