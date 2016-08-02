React = require 'react'
assign = require 'lodash/assign'


field-changed = (props, e) !->
    props.mutator.set e.target.value


export Field = (props, component) ->
    React.cloneElement component, value: props.mutator.val, on-change: field-changed.bind(null, props)


export Pure = $$ React.create-class do
    shouldComponentUpdate: (props, state) ->
        @props.by != props.by

    render: ->
        # console.log 'Pure render', @props
        @props.children!
