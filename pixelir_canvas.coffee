#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# PIXEL and WEBGL canvas library - pixelir_canvas.coffee
#
# 2016.11.17 Created by PROJECT PROMINENCE
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

class pixelir_canvas
    # public variable
    @ASSETS = undefined
    @BROWSER_WIDTH = undefined
    @BROWSER_HEIGHT = undefined
    @SCREEN_WIDTH = undefined
    @SCREEN_HEIGHT = undefined

    # private variable
    _BASE = undefined
    _POSX = undefined
    _POSY = undefined
    _DOT_BY_DOT = undefined
    _CANVAS_WIDTH = undefined
    _CANVAS_HEIGHT = undefined
    _CANVASLIST = undefined

#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# constructor
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

    constructor:(arr)->
        if (!arr?)
            arr = []

        # get  size
        @BROWSER_WIDTH = window.innerWidth
        @BROWSER_HEIGHT = window.innerHeight
        @SCREEN_WIDTH = if (arr['screen_width']?) then arr['screen_width'] else @BROWSER_WIDTH
        @SCREEN_HEIGHT = if (arr['screen_height']?) then arr['screen_height'] else @BROWSER_HEIGHT

        # set canvas parameter
        _BG_COLOR = if (arr['bg_color']?) then arr['bg_color'] else undefined
        _CANVAS_COLOR = if (arr['canvas_color']?) then arr['canvas_color'] else "black"
        _DOT_BY_DOT = if (arr['dot_by_dot']?) then arr['dot_by_dot'] else false
        _POSX = if (arr['posx']?) then arr['posx'] else undefined
        _POSY = if (arr['posy']?) then arr['posy'] else undefined
        _CANVASLIST = []

        @__initCanvas
            bg_color: _BG_COLOR
            canvas_color: _CANVAS_COLOR

#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# public method
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

    #========================================================================
    # create new canvas
    #========================================================================
    createCanvas:(arr = {})->
        hidden = if (arr['hidden']?) then arr['hidden'] else false
        type = if (arr['type']?) then arr['type'] else '2d'
        if (type == "2d")
            newcanvas = @__createPixelCanvas(hidden)
        else if (type == "gl")
            newcanvas = @__createWebGLCanvas(hidden)
        else
            newcanvas = undefined
        _CANVASLIST.push(newcanvas)
        return newcanvas

    #========================================================================
    # remove canvas
    #========================================================================
    removeCanvas:(canvas)->
        _BASE.removeChild(canvas)
        num = _CANVASLIST.indexOf(canvas)

    #========================================================================
    # clear canvas
    #========================================================================
    clearCanvas:(canvas)->
        ctx = canvas.getContext('2d')
        ctx.clearRect(0, 0, canvas.width, canvas.height)

    #========================================================================
    # set background color on canvas
    #========================================================================
    setBackgroundColor:(color, canvas)->
        canvas.style.background = color


#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# private method
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

    #========================================================================
    # init base DIV
    #========================================================================
    __initCanvas:(arr)->
        # initialize 2D canvas
        @__initWebcanvas()

    #========================================================================
    # create 2D canvas
    #========================================================================
    __createPixelCanvas:(hidden)->
        return @__createWebcanvas2d(hidden)

    #========================================================================
    # create WebGL canvas
    #========================================================================
    __createWebGLCanvas:(hidden)->
        return @__createWebcanvas3d(hidden)



#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# Webcanvas method
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

    #========================================================================
    # init webcanvas 2d canvas
    #========================================================================
    __createWebcanvas2d:(hidden)->
        # create Pixel CANVAS
        newcanvas = document.createElement("canvas")
        newcanvas.style.position = "absolute"
        newcanvas.style.background = "transparent"
        newcanvas.style.overflow = "hidden"
        newcanvas.style.width = "100%"
        newcanvas.style.height = "100%"
        newcanvas.style.left = "0px"
        newcanvas.style.top = "0px"
        if (hidden)
            newcanvas.style.visibility = "hidden"
        else
            newcanvas.style.visibility = "visible"
        newcanvas.setAttribute("width", @SCREEN_WIDTH)
        newcanvas.setAttribute("height", @SCREEN_HEIGHT)
        _BASE.appendChild(newcanvas)
        return newcanvas

    #========================================================================
    # init webcanvas 3d canvas
    #========================================================================
    __createWebcanvas3d:(hidden)->
        # create WebGL CANVAS
        newcanvas = document.createElement("canvas")
        newcanvas.style.position = "absolute"
        newcanvas.style.background = "transparent"
        newcanvas.style.overflow = "hidden"
        newcanvas.style.width = "100%"
        newcanvas.style.height = "100%"
        newcanvas.style.left = "0px"
        newcanvas.style.top = "0px"
        if (hidden)
            newcanvas.style.visibility = "hidden"
        else
            newcanvas.style.visibility = "visible"
        newcanvas.setAttribute("width", @SCREEN_WIDTH)
        newcanvas.setAttribute("height", @SCREEN_HEIGHT)
        _BASE.appendChild(newcanvas)

        # 標準コンテキストの取得を試みる。失敗した場合は、experimental にフォールバックする。
        gl = newcanvas.getContext("webgl") || newcanvas.getContext("experimental-webgl")

        if (gl?)
            gl.clearColor(0.0, 0.0, 0.0, 1.0)
            gl.enable(gl.DEPTH_TEST)
            gl.depthFunc(gl.LEQUAL)
            gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
            gl.viewport(0, 0, newcanvas.width, newcanvas.height)
        else
            console.log("WebGL not initialize.")
            newcanvas = undefined
        return newcanvas

    #========================================================================
    # Webcanvas canvas init
    #========================================================================
    __initWebcanvas:(arr = {})->
        bg_color = if (arr['bg_color']?) then arr['bg_color'] else "gray"
        canvas_color = if (arr['canvas_color']?) then arr['canvas_color'] else "black"

        # set background color of BODY
        body = document.body
        if (bg_color?)
            body.style.background = bg_color

        # create base DIV
        _BASE = document.createElement("div")
        _BASE.style.position = "relative"
        _BASE.style.background = canvas_color
        _BASE.style.overflow = "hidden"
        body.appendChild(_BASE)

        # set fullscreen
        if (!_DOT_BY_DOT)
            ratio = @SCREEN_WIDTH / @SCREEN_HEIGHT
            _CANVAS_WIDTH = @BROWSER_WIDTH
            _CANVAS_HEIGHT = @BROWSER_WIDTH / ratio
            diff_x = 0
            diff_y = (@BROWSER_HEIGHT - _CANVAS_HEIGHT) / 2
            if (_CANVAS_HEIGHT > @BROWSER_HEIGHT)
                _CANVAS_WIDTH = @BROWSER_HEIGHT * ratio
                _CANVAS_HEIGHT = @BROWSER_HEIGHT
                diff_x = (@BROWSER_WIDTH - _CANVAS_WIDTH) / 2
                diff_y = 0
        else
            if (!_POSX?)
                diff_x = (@BROWSER_WIDTH - @SCREEN_WIDTH) / 2
            else
                diff_x = _POSX
            if (!_POSY?)
                diff_y = (@BROWSER_HEIGHT - @SCREEN_HEIGHT) / 2
            else
                diff_y = _POSY
            _CANVAS_WIDTH = @SCREEN_WIDTH
            _CANVAS_HEIGHT = @SCREEN_HEIGHT

        _BASE.style.width = _CANVAS_WIDTH+"px"
        _BASE.style.height = _CANVAS_HEIGHT+"px"
        _BASE.style.left = diff_x+"px"
        _BASE.style.top = diff_y+"px"

