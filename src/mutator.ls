require! {
    'lodash/isArray'
    'lodash/isObject'
    'lodash/assign'
}


get-mutator = (data) ->
    if is-array data
        ListMutator
    else if is-object data
        ObjectMutator
    else
        ValueMutator


root-parent = (data, on-change, get)->
    val = data
    set: ->
        val := it;
        on-change it if on-change
        it
    get: get or -> val


GetMutator =
    to: (key, value) ->
        data = @get![key] or value
        M = get-mutator data
        new M @get-parent(key), data

    detach: (on-change) ->
        oldparent = @parent
        ^^@ <<< parent: root-parent null, on-change, oldparent~get


class Value
    (@parent) ->

    val:~ -> @parent.get!
    set: (val) -> @parent.set val
    get: -> @parent.get!


GetParent =
    get-parent: (key) ->
        set: @set-key.bind(@, key)
        get: @get-key.bind(@, key)
        key: key


class ValueMutator extends Value


class ObjectMutator extends Value implements GetMutator, GetParent
    set-key: (key, val) ->
        obj = assign {}, @val, (key): val
        @set obj

    get-key: (key) -> @get![key]

    merge: (val) ->
        @set assign {}, @val, val


class ListMutator extends Value implements GetMutator, GetParent
    set-key: (key, val) ->
        obj = @val.slice!
        obj[key] = val
        @set obj

    get-key: (key) -> @get![key]

    push: (val) ->
        obj = @val.slice!
        obj.push(val)
        @set obj

    pop: (val) ->
        obj = @val.slice!
        obj.pop(val)
        @set obj


module.exports = (data, onchange) ->
    M = get-mutator data
    new M root-parent data, onchange
