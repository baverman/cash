React = require 'react'
assign = require 'lodash/assign'


field-changed = (coerce, prepare, props, event) !->
    val = event.target.value
    if coerce
        try
            val = coerce val
        catch
            console.log e
            # event.target.focus!
            return true

        if prepare
            event.target.value = prepare val

    props.mutator.set val


export Field = (coerce, prepare) ->
    (props, component) ->
        val = props.mutator.val
        if prepare
            val = prepare val
        React.cloneElement do
            component
            defaultValue: val
            on-blur: field-changed.bind(null, coerce, prepare, props)


export TextField = Field!


export Pure = $$ React.create-class do
    shouldComponentUpdate: (props, state) ->
        @props.by != props.by

    render: ->
        # console.log 'Pure render', @props
        @props.children!
