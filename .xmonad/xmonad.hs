import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.MarkAsUrgent (markAsUrgent)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Flip (Flip(..))
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspaces)
import XMonad.Layout.ResizableTile (MirrorResize(MirrorExpand, MirrorShrink), ResizableTall(..))
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad

import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Monoid (All (All), mappend)

import Control.Monad (when)

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel"   --> doIgnore
    , className =? "Unity-2d-lancher" --> doIgnore
    , className =? "Empathy"          --> doF (W.shift "3") <+> markAsUrgent
    , className =? "Pidgin"           --> doF (W.shift "3") <+> markAsUrgent
    , className =? "Steam"            --> doFloat        --   <+> doIgnore
    , className =? "steam"            --> doFullFloat  -- bigpicture-mode
    , isFullscreen                    --> doFullFloat
    , isDialog                        --> doCenterFloat
    ]) <+> namedScratchpadManageHook myScratchPads

-- mod1Mask = (left alt)
-- mod2Mask = (right alt)
-- mod4Mask = (super)
myModMask = mod1Mask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myScratchPads = [ NS "pandora" spawnPandora findPandora (rightPanel 0.5)
                , NS "rdio"    spawnRdio    findRdio    (rightPanel 0.67)
                , NS "pidgin"  spawnPidgin  findPidgin  (rightPanel 0.25)
                ]
  where
    spawnPandora = "/opt/google/chrome/chrome '--app=http://www.pandora.com/'"
    findPandora = resource =? "www.pandora.com"

    spawnRdio = "/opt/google/chrome/chrome '--app=http://www.rdio.com/'"
    findRdio = resource =? "www.rdio.com"

    spawnPidgin = "pidgin"
    findPidgin  = role =? "buddy_list"

    rightPanel w = customFloating $ W.RationalRect l t w h
      where
        h = 1
        t = 1 - h
        l = 1 - w

    role = stringProperty "WM_WINDOW_ROLE"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: [(String, X ())]
myKeys =
    [
      ("M-<Backspace>", focusUrgent)
    , ("M-S-<Backspace>", clearUrgents)

    , ("M-b", sendMessage ToggleGaps)
    , ("M-a", sendMessage MirrorShrink)
    , ("M-;", sendMessage MirrorExpand)

    -- TODO: These screen-switching shortcuts conflict with browser
    -- history shortcuts.
    --, ("M-<Right>", nextScreen)
    --, ("M-<Left>",  prevScreen)
    --, ("M-S-<Right>", shiftNextScreen)
    --, ("M-S-<Left>",  shiftPrevScreen)
    , ("M-s", nextScreen)
    , ("M-S-s", swapNextScreen)
    , ("M-z", toggleWS)

    -- NamedScratchPad shortcuts
    -- TODO: These shortcuts currently override the default key for
    -- reducing the number of windows on the left side of the screen.
    , ("M-, p", namedScratchpadAction myScratchPads "pandora")
    , ("M-, r", namedScratchpadAction myScratchPads "rdio")
    , ("M-, b", namedScratchpadAction myScratchPads "pidgin")
    ]

myWorkspaceKeys :: [((ButtonMask, KeySym), X ())]
myWorkspaceKeys =
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    -- These are custom versions of the workspace switching keys that do
    -- not swap workspaces between screens if the workspace being
    -- switched to is on a screen that is visible, but that is not
    -- active.
    [((m .|. myModMask, k), windows $ f i)
        | (i, k) <- zip (myWorkspaces) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayouts = smartBorders $ gaps [(U, 24)] $ onWorkspaces ["1", "4", "7", "8"] leftTiled tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = ResizableTall nmaster delta ratio []

    -- like tiled, but puts the master window on the right
    leftTiled = Flip tiled

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Event Hooks:

-- Helper functions to fullscreen the window
fullFloat, tileWin :: Window -> X ()
fullFloat w = windows $ W.float w r
    where r = W.RationalRect 0 0 1 1
tileWin w = windows $ W.sink w

fullscreenEventHook :: Event -> X All
fullscreenEventHook (ClientMessageEvent _ _ _ dpy win typ dat) = do
    state <- getAtom "_NET_WM_STATE"
    fullsc <- getAtom "_NET_WM_STATE_FULLSCREEN"
    isFull <- runQuery isFullscreen win

    -- Constants for the _NET_WM_STATE protocol
    let remove = 0
        add = 1
        toggle = 2

        -- The ATOM property type for changeProperty
        ptype = 4

        action = head dat

    when (typ == state && (fromIntegral fullsc) `elem` tail dat) $ do
        when (action == add || (action == toggle && not isFull)) $ do
            io $ changeProperty32 dpy win state ptype propModeReplace [fromIntegral fullsc]
            fullFloat win
        when (head dat == remove || (action == toggle && isFull)) $ do
            io $ changeProperty32 dpy win state ptype propModeReplace []
            tileWin win

    -- It shouldn't be necessary for xmonad to do anything more with this event
    return $ All False

fullscreenEventHook _ = return $ All True

------------------------------------------------------------------------
-- Putting it all together
main = xmonad $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }
                                 urgencyConfig { suppressWhen = Focused }
              $ gnomeConfig
              { modMask = myModMask
              , workspaces = myWorkspaces
              , manageHook = myManageHook
              , handleEventHook = handleEventHook gnomeConfig `mappend` fullscreenEventHook
              , layoutHook = myLayouts
              , startupHook = setWMName "LG3D"
              } `additionalKeysP` myKeys `additionalKeys` myWorkspaceKeys
