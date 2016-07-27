max = require 'lodash/max'

transactions =
  * id: 1
    date: '2016-06-24 23:06:01'
    src:  'cash'
    description: 'Пицца'
    dest: 'food:shop'
    amount: 50000
    currency: 'RUB'
    group: [1, 2, 3]
  * id: 2
    date: '2016-06-24 23:06:01'
    src:  'debt:tolya'
    dest: 'food:shop'
    amount: 15000
    currency: 'RUB'
    group: [1, 2, 3]
  * id: 3
    date: '2016-06-28 24:05:01'
    src:  'cash'
    dest: 'debt:tolya'
    amount: 15000
    currency: 'RUB'
    group: [1, 2, 3]
  * id: 4
    date: '2016-06-25 23:06:01'
    src:  'card:alfa:main'
    dest: 'cash'
    amount: 490000
    currency: 'RUB'
  * id: 5
    date: '2016-06-26 23:06:01'
    src:  'card:alfa:credit'
    dest: 'food:restaurant'
    amount: 98056
    currency: 'RUB'
  * id: 6
    date: '2016-07-26 23:06:01'
    src:  'salary'
    dest: 'cash'
    amount: 15000000
    currency: 'RUB'


types =
    'cash': true
    'card:alfa:main': true
    'card:alfa:credit': true
    'debt:tolya': true


export create = (transactions) ->
    transactions: transactions
    tmap: {[t.id, t] for t in transactions}
    types: types
    next-id: max(transactions, 'id') + 1

    get-type: (src, dest, amount) !->
        st = src of @types
        dt = dest of @types

        if st and dt
            return 'transfer'

        if st
            if amount > 0
                return 'expense'
            else
                return 'income'

        if dt
            if amount > 0
                return 'income'
            else
                return 'expense'

        return 'unknown'


export get = ->
    create(transactions)
