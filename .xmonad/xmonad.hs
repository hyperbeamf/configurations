import XMonad 
import XMonad.Hooks.DynamicLog 
import XMonad.Hooks.ManageDocks 
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Util.NamedScratchpad                  -- Named Scratchpads
import XMonad.Layout.Spacing                        -- Gaps
import XMonad.Layout.NoBorders
import Data.Monoid
import System.Exit
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

cTerminal    = "urxvt"
cBorderW     = 4
cModMask     = mod4Mask
cDefGaps     = [(15,0,0,0)]
cWorkspaces  = ["1","2","3","4","5","6","7","8","9","10"]
cNormalColor = "#3c3836"
cFocusColor  = "#a89984"
cFocusFollowsMouse :: Bool
cFocusFollowsMouse = True
-- cBar      = "xmobar"


-- The next part is pasted from the XMonad example config which is bad practice but i'll probably eventually change it
-- Keyword probably though, as I may not lol

cKeyBindings conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- Terminal keybind
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    -- Scratchpads
    , ((modm .|. controlMask,    xK_e), namedScratchpadAction cScratchpads "emacs")
    , ((modm .|. controlMask,    xK_c), namedScratchpadAction cScratchpads "dropdown_terminal")
    -- dmenu
    , ((modm,               xK_d     ), spawn "exe=`dmenu_run`")
    -- close focused window
    , ((modm .|. shiftMask, xK_w     ), kill)
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    -- Switch/Move window to workspace N script
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

cMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]


cManageHook = composeAll                           -- Window management hook
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    ]

cLayout = tiled ||| Mirror tiled ||| noBorders Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = spacing 5 $ Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
    
------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--

cEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
cLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
cStartupHook = do
  spawn "feh --bg-fill ~/Pictures/Wallpapers/wallhaven-0pe613.jpg" -- Wallpaper
  spawn "xrdb ~/.Xresources"                                       -- Xresources startup
  spawn "sxhkd"                                                    -- Hotkeys

cScratchpads = [ NS "emacs" initEmacs dropEmacs mangEmacs          -- Named Scratchpads
               ]
               where
                 initEmacs    = "emacs --name=dropemacs"
                 dropEmacs    = resource =? "dropemacs"
                 mangEmacs    = customFloating $ W.RationalRect l t w h
                              where
                                h = 0.9
                                w = 0.9
                                t = 0.95 -h
                                l = 0.95 -w
                 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad defaults


-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = cTerminal,
        focusFollowsMouse  = cFocusFollowsMouse,
        borderWidth        = cBorderW,
        modMask            = cModMask,
        -- numlockMask deprecated in 0.9.1
        -- numlockMask        = myNumlockMask,
        workspaces         = cWorkspaces,
        normalBorderColor  = cNormalColor,
        focusedBorderColor = cFocusColor,

      -- key bindings
        keys               = cKeyBindings,
        mouseBindings      = cMouseBindings,

      -- hooks, layouts
        layoutHook         = cLayout,
        manageHook         = cManageHook,
        handleEventHook    = cEventHook,
        logHook            = cLogHook,
        startupHook        = cStartupHook
    }
