React = require 'react'
require! {
    'lodash/assign'
    'lodash/padStart'
}


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


pad2 = pad-start _, 2, '0'


export date-format = ->
    year = it.get-full-year!
    month = pad2 it.get-month! + 1
    day = pad2 it.get-date!
    hour = pad2 it.get-hours!
    minute = pad2 it.get-minutes!
    second = pad2 it.get-seconds!
    "#year-#month-#day #hour:#minute:#second"
