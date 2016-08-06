require! {
    'lodash/max'
    'lodash/sortBy'
    'lodash/sortedIndexBy'
    'lodash/split'
    'lodash/sum'
}


class Balance
    ->
        @amount = 0
        @sub = {}

    children: ->
        return [@amount].concat [r.balance! for _, r of @sub]

    balance: ->
        sum @children!

    dr-cr: ->
        debit = 0
        credit = 0
        for s in @children!
            if s < 0
                credit -= s
            else
                debit += s

        return {debit, credit}

    get-sub: ->
        b = @sub[it]
        if not b
            b = @sub[it] = new Balance
        return b

    get: ->
        [_, ...rest] = split it, ':'
        result = this
        for r in rest
            result = result.get-sub r
        return result

    add: ->
        @amount += it


class TStore
    (@on-change) ->

    init: (transactions) !->
        transactions = sort-by transactions, 'date'
        @transactions = transactions
        @tmap = {[t.id, t] for t in transactions}
        @next-id = max(transactions, 'id') + 1

        @balance = new Balance
        for t in transactions
            @balance-add t

    balance-modify: (it, m) !->
        if it.src[0] == ':'
            @balance.get it.src .add -it.amount * m
        if it.dest[0] == ':'
            @balance.get it.dest .add it.amount * m

    balance-add: ->
        @balance-modify it, 1

    balance-revert: ->
        @balance-modify it, -1

    find: ->
        idx = sorted-index-by @transactions, it, 'date'
        val = @transactions[idx]
        while val and val.date == it.date
            if val.id == it.id
                return idx
            idx++
            val = @transactions[idx]

        return null

    add: !->
        it.id = ++@next-id
        @tmap[it.id] = it
        idx = sorted-index-by @transactions, it, 'date'
        @transactions.splice idx, 0, it
        @balance-add it
        @on-change ^^@

    save: !->
        old = @get(it.id)
        @tmap[it.id] = it
        if old.date != it.date
            idx = @find old
            if idx != null
                @transactions.splice idx, 1
            idx = sorted-index-by @transactions, it, 'date'
            @transactions.splice idx, 0, it

        if old.group != it.group
            group = it.group
            for tid in old.group or []:
                t = @tmap[tid]
                t && t.group = []

            for tid in group or []:
                t = @tmap[tid]
                t && t.group = group

        @balance-revert old
        @balance-add it
        @on-change ^^@

    get: (tid) ->
        @tmap[tid]

    get-type: (src, dest, amount) !->
        st = src[0] == ':'
        dt = dest[0] == ':'

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
    store = new TStore ...
    store.init transactions
    store


transactions =
  * id: 1
    date: '2016-06-24 23:06:01'
    src:  ':cash'
    description: 'Пицца'
    dest: 'food:shop'
    amount: 50000
    currency: 'RUB'
    group: [1, 2, 3]
  * id: 2
    date: '2016-06-24 23:06:01'
    src:  ':debt:tolya'
    dest: 'food:shop'
    amount: 15000
    currency: 'RUB'
    group: [1, 2, 3]
  * id: 3
    date: '2016-06-28 24:05:01'
    src:  ':cash'
    dest: ':debt:tolya'
    amount: 15000
    currency: 'RUB'
    group: [1, 2, 3]
  * id: 4
    date: '2016-06-25 23:06:01'
    src:  ':card:alfa:main'
    dest: ':cash'
    amount: 490000
    currency: 'RUB'
  * id: 5
    date: '2016-06-26 23:06:01'
    src:  ':card:alfa:credit'
    dest: 'food:restaurant'
    amount: 98056
    currency: 'RUB'
  * id: 6
    date: '2016-07-26 23:06:01'
    src:  'salary'
    dest: ':cash'
    amount: 15000000
    currency: 'RUB'
    description: 'Моя ненаглядная зарплата'
