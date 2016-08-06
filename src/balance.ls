React = require 'react'

require! {
    'lodash/keys'
    './util.ls': {Pure}
    './balance.css': style
}


export Total = $$$ (props) -> Pure on: props.tstore, ->
    b = props.tstore.balance.dr-cr!
    $table class-name: style.balance,
        $tbody null,
            $tr null,
                $td null,
                    $span class-name: style.debit, "#{b.debit / 100.0}"
                    '\u00a0\u2212\u00a0'
                    $span class-name: style.credit, "#{b.credit / 100.0}"
                $td class-name: style.right,
                    '=\u00a0'
                    $span class-name: style.total, "#{(b.debit - b.credit) / 100.0}"


export balance-tree = (root, level, result) ->
    names = keys root.sub
    names.sort!
    for name in names
        sub = root.sub[name]
        result.push [name, sub, level]
        balance-tree sub, level + 1, result

    return result


export Accounts = $$$ (props) -> Pure on: props.tstore, ->
    $div class-name: 'full',
        $div do
            class-name: 'scroll'
            style:
                height: 'calc(100% - 2rem - 1.4rem)'
                padding: '1rem 1rem 0 1rem'
            $table class-name: style.account-list, $tbody null,
                for [name, b, level] in balance-tree props.tstore.balance, 0, []
                    amount = b.balance() / 100.0
                    $tr key: "#{level}-#{name}",
                        $td style: padding-left: "#{level * 1.5}rem", name
                        $td null,
                            $span do
                                class-name: if amount < 0 then style.credit else style.debit
                                amount
        $div class-name: 'mui-panel', style: padding: '1rem',
            Total tstore: props.tstore
