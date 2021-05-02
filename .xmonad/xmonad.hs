-- IMPORTS 
import XMonad
import XMonad.Config.Xfce
-- DATA and STACK
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Ratio
-- ACTION
import XMonad.Actions.CopyWindow
-- LAYOUT
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.CenteredMaster
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Hidden
-- HOOKS
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
--
-- DEFAULT PROGRAM
--
myTerminal      = "qterminal"
myBrowser       = "qutebrowser"
myEntBrowser    = "brave"
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False
--
-- Width of the window border in pixels.
--
myBorderWidth   = 2
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask
--
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#2b211c"
myFocusedBorderColor = "#c47926"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    
    -- launch brave browser
    --, ((modm,               xK_w     ), spawn "brave")
    --, ((0, 0x1008ff41), spawn "brave")
    , ((modm,               xK_o     ), spawn myEntBrowser)
    -- launch qutebrowser
    , ((modm,               xK_w     ), spawn myBrowser)
    -- Hide xfce bar
    , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts)
    -- launch rofu
    , ((modm,               xK_p     ), spawn "rofi -modi drun -show drun")
    -- close focused window
    , ((modm,               xK_q     ), kill)
    -- close focused windowspawn "xfce4-session-logout"
    , ((modm .|. shiftMask, xK_q     ), spawn "xfce4-session-logout")
    
    --hide windows
    , ((modm,               xK_backslash), withFocused hideWindow)
    -- unhide windows
    , ((modm,               xK_a), popOldestHiddenWindow)
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
    --
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Restart xmonad
    , ((modm              , xK_r     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:
--
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myLayout = smartSpacing 3 $ hiddenWindows (tiled) ||| Full ||| centerMaster Grid -- smartBorders(tiled)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
--
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

myNewManageHook = composeAll . concat $
    [ [ className =? c --> doRectFloat (W.RationalRect 0.683 0.68 0.31 0.31) | c <- myPIPFloatPosition ]
    , [ className =? c --> doFloat       | c <- myFloatsC ]
    , [ resource  =? c --> doIgnore      | c <- myIgnoreR ]
    , [ className =? c --> doF copyToAll | c <- myCpToAll ]
    , [ className =? c --> doShift "8"   | c <- myShiftC8 ]
    , [ className =? c --> doShift "9"   | c <- myShiftC9 ]
    , [ title     =? c --> doShift "9"   | c <- myShiftT9 ]
    ]
    where myPIPFloatPosition = [""]
          myFloatsC = ["mPlayer", "Gimp"]
          myIgnoreR = ["desktop_window", "kdesktop"]
	  myCpToAll = [""]
	  myShiftC8 = ["brave-browser", "Brave-browser"]
	  myShiftC9 = ["discord", "discord", "spotify", "Spotify"]
	  myShiftT9 = ["Spotify"]

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
--
-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad xfceConfig
	{
   		-- simple stuff          
     		terminal           = myTerminal,
     		focusFollowsMouse  = myFocusFollowsMouse,
     		clickJustFocuses   = myClickJustFocuses,
    		borderWidth        = myBorderWidth,
     		modMask            = myModMask,             
     		workspaces         = myWorkspaces,                              
     		normalBorderColor  = myNormalBorderColor,         
     		focusedBorderColor = myFocusedBorderColor,
                                                               
   		-- key bindings                                                   
     		keys               = myKeys,                        
     		mouseBindings      = myMouseBindings,

   		-- hooks, layouts
     		layoutHook         = avoidStruts $ myLayout,
     		manageHook         = manageDocks <+> myNewManageHook, -- <+> manageHook defaultConfig, -- myManageHook,
     		handleEventHook    = ewmhDesktopsEventHook, -- myEventHook,
     		logHook            = ewmhDesktopsLogHook, -- myLogHook,
     		startupHook        = ewmhDesktopsStartup <+> setWMName "LG3D"
  	}
