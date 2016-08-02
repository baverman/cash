class Router
    (settings) ->
        @ <<< settings
        if location.hash
            @handle!
        else
            init = @default!
            @set-hash init
            @on-change init

        setTimeout ~>
            window.addEventListener 'hashchange' @handle

    set-hash: !->
        location.hash = it |> JSON.stringify

    set-state: !->
        window.removeEventListener 'hashchange' @handle
        @set-hash it
        @on-change it
        setTimeout ~>
            window.addEventListener 'hashchange' @handle

    get-hash: ->
        if location.hash
        then location.hash |> (.slice 1) |> JSON.parse
        else null

    handle: !~>
        console.trace 'Router handle'
        it?.prevent-default!
        it?.stop-propagation!
        ui = @get-hash!
        if ui
            @on-change ui


module.exports = ->
    new Router ...
