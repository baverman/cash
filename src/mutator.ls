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


GetMutator =
    mutator: (key) ->
        m = @cache[key]
        if not m
            data = @val[key]
            M = get-mutator data
            m = new M @get-parent(key), data
            @cache[key] = m
        return m

    detach: (on-change) ->
        obj = ^^@
        obj.parent = if on-change
                     then set: on-change
                     else null
        return obj


SetValue =
    set: (val) ->
        @val = val
        if @parent
            @parent.set val
        else
            val


GetParent =
    get-parent: (key) ->
        set: @set-key.bind(@, key)
        key: key


class ValueMutator implements SetValue
    (@parent, @val) ->


class ObjectMutator implements SetValue, GetMutator, GetParent
    (@parent, @val) ->
        @cache = {}

    set-key: (key, val) ->
        delete @cache[key]
        obj = assign {}, @val, (key): val
        @set obj


class ListMutator implements SetValue, GetMutator, GetParent
    (@parent, @val) ->
        @cache = {}

    set-key: (key, val) ->
        delete @cache[key]
        obj = @val.slice!
        obj[key] = val
        @set obj

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
    new M set: onchange, data
