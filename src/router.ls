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
            window.addEventListener 'hashchange' @~handle

    set-hash: !->
        location.hash = it |> JSON.stringify

    get-hash: ->
        if location.hash
        then location.hash |> (.slice 1) |> JSON.parse
        else null

    handle: !->
        it?.prevent-default!
        it?.stop-propagation!
        ui = @get-hash!
        if ui
            @on-change ui


module.exports = ->
    new Router ...
